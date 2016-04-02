//
//  Client+RepositorySpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift

class ClientRepositorySpec: QuickSpec {
  override func spec() {
    describe("without a user") {
      var client: Client!
    
      beforeEach {
        client = Client(server: Server.dotComServer)
      }
      
      it("should GET a repository") {
        self.stub(uri("/repos/octokit/octokit.objc"), builder: jsonData(Helper.read("repository")))
        
        let observable = client.fetchRepository(name: "octokit.objc", owner: "octokit")
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case .Error(_):
              fail()
            case let .Next(repository):
              expect(repository.objectID).to(equal("7530454"))
              expect(repository.name).to(equal("octokit.objc"))
              expect(repository.ownerLogin).to(equal("octokit"))
              expect(repository.repoDescription).to(equal("GitHub API client for Objective-C"))
              expect(repository.defaultBranch).to(equal("master"))
              expect((repository.isPrivate)).to(beFalse())
              expect((repository.isFork)).to(beFalse())
              expect(repository.datePushed).to(equal(Formatter.date(string: "2013-07-08T22:08:31Z")))
              expect(repository.SSHURLString).to(equal("git@github.com:octokit/octokit.objc.git"))
              expect(repository.HTTPSURL).to(equal(NSURL(string:"https://github.com/octokit/octokit.objc.git")))
              expect(repository.gitURL).to(equal(NSURL(string:"git://github.com/octokit/octokit.objc.git")))
              expect(repository.htmlURL).to(equal(NSURL(string:"https://github.com/octokit/octokit.objc")))
              expectation.fulfill()
            default:
              break
            }
          }
        }
      }
      
      it("should return nothing if repository is unmodified") {
        self.stub(uri("/repos/octokit/octokit.objc"), builder: http(304))
        
        let observable = client.fetchRepository(name: "octokit.objc", owner: "octokit")
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case .Error(_):
              fail()
            case .Next:
              fail()
            case .Completed:
              expectation.fulfill()
            }
          }
        }
      }
      
      it("should not GET a non existing repository") {
        self.stub(uri("/repos/octokit/repo-does-not-exist"), builder: http(404))
        
        let observable = client.fetchRepository(name: "repo-does-not-exist", owner: "octokit")
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case let .Error(error):
              expect(error).toNot(beNil())
              expectation.fulfill()
            case .Next:
              fail()
            case .Completed:
              fail()
            }
          }
        }
      }
      
      it("should not treat all 404s like old server versions") {
        self.stub(uri("/repos/octokit/octokit.objc"), builder: http(404))
       
        let observable = client.fetchRepository(name: "octokit.objc", owner: "octokit")
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case let .Error(error):
              let error = error as NSError
              expect(error.code).to(equal(404))
              expect(error.domain).to(equal(Client.Constant.errorDomain))
              expectation.fulfill()
            case .Next:
              fail()
            case .Completed:
              fail()
            }
          }
        }
      }
      
    }
  }
}

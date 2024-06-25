struct Profile {
  let username: String
  let name: String
  let loginName: String
  let bio: String?
  
  init(from profileResult: ProfileResult) {
    self.username = profileResult.userName
    self.name = profileResult.firstName + " " + profileResult.lastName
    self.loginName = "@" + profileResult.userName
    self.bio = profileResult.userBio
  }
}

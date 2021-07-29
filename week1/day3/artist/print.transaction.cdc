import Artist from "./contract.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {
  
  let picture: @Artist.Picture?
  let collectionRef: &Artist.Collection

  prepare(account: AuthAccount) {
    // TODO: Change to your contract account address.
    let printerRef = getAccount(0x01cf0e2f2f715450)
      .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
      .borrow()
      ?? panic("Couldn't borrow printer reference.")
    
    let canvas = Artist.Canvas(
      width: width,
      height: height,
      pixels: pixels
    )
    self.picture <- printerRef.print(canvas:canvas)
    
    self.collectionRef = account
      .getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
      .borrow()
      ?? panic("Couldn't borrow picture collection reference.")
  }
  
  execute {
    if self.picture == nil {
      destroy self.picture
    } else {
      self.collectionRef.deposit(picture: <- self.picture!)
    }
  }
}
import Artist from 0x02

transaction() {
  
  let pixels: String
  var picture: @Artist.Picture?
  var collectionRef: &Artist.Collection

  prepare(account: AuthAccount) {
    let printerRef = getAccount(0x02)
      .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
      .borrow()
      ?? panic("Couldn't borrow printer reference.")
    
    // Replace with your own drawings.
    self.pixels = "*   * * *   *   * * *   *"
    let canvas = Artist.Canvas(
      width: printerRef.width,
      height: printerRef.height,
      pixels: self.pixels
    )
    
    let collection <- Artist.createCollection()
    
    if !account.getCapability<&Artist.Collection>(/private/collection).check(){
      account.save( <- collection, to:/storage/collection)
      account.link<&Artist.Collection>(/private/collection, target: /storage/collection)
      log("collection create")
    }else{
      log("collection exist")
      destroy collection
    }

    self.collectionRef = account.getCapability<&Artist.Collection>(/private/collection).borrow()?? panic("no collection borrow")
    self.picture <- printerRef.print(canvas: canvas)
  }

  execute {
    if self.picture != nil{
      self.collectionRef.deposit(picture: <- self.picture!)
    }else{
      log("picture not exist")
      destroy self.picture
    }
  }
}
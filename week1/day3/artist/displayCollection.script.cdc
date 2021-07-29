import Artist from "./contract.cdc"

// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String]? {
  let collection = getAccount(address).getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
    .borrow()
    ?? panic("Couldn't borrow picture collection reference.")
    
  let printerRef = getAccount(0x01cf0e2f2f715450)
    .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
    .borrow()
    ?? panic("Couldn't borrow printer reference.")
  var formattedPictures:[String] = []
  let canvases = collection.getCanvases()

  if canvases.length != 0{
    for canvas in canvases{
      let formatPicture = printerRef.display(canvas: canvas)
      formattedPictures.append(formatPicture)
    }
    return formattedPictures
  }else{
    return nil
  }  
}
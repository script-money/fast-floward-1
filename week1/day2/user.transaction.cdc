import Artist from 0x02

pub fun main() {
  // Write a script that prints the contents of collections for all five Playground accounts (0x01, 0x02, etc.). 
  // Please use your framed canvas printer function to log each Picture's canvas in a legible way. 
  // Provide a log for accounts that don't yet have a Collection.
  let addresses = [0x01,0x02,0x03,0x04,0x05] as [Address]
  let printerRef = getAccount(0x02)
      .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
      .borrow()
      ?? panic("Couldn't borrow printer reference.")

  for address in addresses{
    let collectionRef = getAccount(address).getCapability<&Artist.Collection>(/public/collection).borrow()?? panic("account don't yet have a Collection")
    let canvases = collectionRef.getCanvases()
    if canvases.length == 0 {
      for canvas in canvases{
        printerRef.display(Canvas:canvases)
      }
    }else{
     log("account has not have picture")
    }
  }
}

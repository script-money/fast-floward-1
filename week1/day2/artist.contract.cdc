pub contract Artist {

  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      // The following pixels
      // 123
      // 456
      // 789
      // should be serialized as
      // 123456789
      self.pixels = pixels
    }
  }

  pub resource Picture {

    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Printer {

    pub let width: UInt8
    pub let height: UInt8
    pub let prints: {String: Canvas}

    init(width: UInt8, height: UInt8) {
      self.width = width;
      self.height = height;
      self.prints = {}
    }

    pub fun print(canvas: Canvas): @Picture? {
      // Canvas needs to fit Printer's dimensions.
      if canvas.pixels.length != Int(self.width * self.height) {
        return nil
      }

      // Canvas can only use visible ASCII characters.
      for symbol in canvas.pixels.utf8 {
        if symbol < 32 || symbol > 126 {
          return nil
        }
      }

      // Printer is only allowed to print unique canvases.
      if self.prints.containsKey(canvas.pixels) == false {
        let picture <- create Picture(canvas: canvas)
        self.prints[canvas.pixels] = canvas

        return <- picture
      } else {
        return nil
      }
    }

    pub fun display(canvas:Canvas) {
      let newHeight = canvas.height
      let newWidth = canvas.width
      var h: UInt8 = 0
      while h <= newHeight + 1{
        var newBuffer: String = ""
        var w: UInt8 = 0
        while w <= newWidth + 1{
          if h == 0 {
            if w == 0 {
              newBuffer= newBuffer.concat("+")
            } else if w == newWidth + 1 {
              newBuffer= newBuffer.concat("+")
            } else {
              newBuffer= newBuffer.concat("-")
            }
          } else if h == newHeight + 1 {
            if w == 0 {
              newBuffer= newBuffer.concat("+")
            } else if w == newWidth + 1 {
              newBuffer= newBuffer.concat("+")
            } else {
              newBuffer= newBuffer.concat("-")
            }
          }else{
            if w == 0 {
              newBuffer= newBuffer.concat("|")
            } else if w == newWidth + 1 {
              newBuffer= newBuffer.concat("|")
            } else if w == 1{
              let from:Int = Int(h-1) * 5
              let upTo:Int = Int(h) * 5
              newBuffer = newBuffer.concat(canvas.pixels.slice(from:from,upTo:upTo)) 
            }
          }   
          w = w + 1
        }  
        h = h + 1
        log(newBuffer) 
      } 
    }
  }

  pub resource Collection {
    pub let pictures: @[Picture]

    pub fun deposit(picture: @Picture) {
      self.pictures.append(<- picture)
    }

    pub fun getCanvases(): [Canvas] {
      var canvases: [Canvas] = []
      var index = 0
      while index < self.pictures.length {
        canvases.append(
          self.pictures[index].canvas
        )
        index = index + 1
      }
      return canvases;
    }

    init() {
      self.pictures <- []
    }

    destroy() {
      destroy self.pictures
    }
  }

  pub fun createCollection(): @Collection{
    return <- create Collection()
  }

  init() {
    self.account.save(
      <- create Printer(width: 5, height: 5),
      to: /storage/ArtistPicturePrinter
    )
    self.account.link<&Printer>(
      /public/ArtistPicturePrinter,
      target: /storage/ArtistPicturePrinter
    )
  }
}
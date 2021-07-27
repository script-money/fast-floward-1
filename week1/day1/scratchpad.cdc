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

pub fun serializeStringArray(_ lines: [String]): String {
  var buffer = ""
  for line in lines {
    buffer = buffer.concat(line)
  }
  return buffer
}

pub resource Picture {

  pub let canvas: Canvas
  
  init(canvas: Canvas) {
    self.canvas = canvas
  }
}

pub fun display(canvas: Canvas) {
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

pub resource Printer {
  pub fun print(canvas: Canvas): @Picture?{
    let picture <- create Picture(canvas:canvas)
    display(canvas:picture.canvas)
    return <- picture
  }
}

pub fun main() {
  let pixelsX = [
    "*   *",
    " * * ",
    "  *  ",
    " * * ",
    "*   *"
  ]
  let canvasX = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )
  let letterX <- create Picture(canvas: canvasX)
  let _canvas = letterX.canvas
  log("W1Q1")
  display(canvas:_canvas)
  destroy letterX

  log("W1Q2")
  log("First Printer")
  let printerX <- create Printer()
  // only use once
  let pictureX <- printerX.print(canvas:canvasX)
  destroy printerX
  destroy pictureX

  log("Second Printer")
  let printerY <- create Printer()
  let pictureY <- printerY.print(canvas:canvasX)
  destroy printerY
  destroy pictureY
}
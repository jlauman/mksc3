import scala.scalajs.js
import scala.scalajs.js.annotation._

@js.native
@JSGlobal
def breakpoint(debug: Boolean, message: String): Boolean = js.native

@JSExportTopLevel(name = "Hello3", moduleID = "hello3")
object Hello3 {

  @JSExport
  def hello(name: String = "UNKNOWN"): Unit = {
    println(s"Hello3: Hello ${name}!")
    var args: List[String] = List("one", "two", "three")
    val count = args.length
    // breakpoint(true, "what?")
    println(s"Hello3: names=${args.toList}")
    println(s"Hello3: count=${count}")
  }
}

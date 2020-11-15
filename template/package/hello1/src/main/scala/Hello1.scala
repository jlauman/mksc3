
@main def Hello1(names: String*) =
  val count = names.length
  println(s"Hello1: names=${names}")
  println(s"Hello1: count=${count}")

package task_1

//Exercise 2: Set and Map collections can also be mutable. Figure out how to make them mutable

object part_2 {
  var s1: Set[Int] = Set(5, 1, 3, 2, 4)

  def result() : Unit = {
    s1 = s1.map(x => x * x)
  }

  def main(args: Array[String]): Unit = {
    println(s1) //before immutable set
    result()
    println(s1) //after mutable set
  }
}

package task_1

//Exercise 1: In Scala, there are many ways to do something, similarly, there are many ways to make an
//Array. Think of other ways to make an Array. Write them down and test them to see if they work.

object part_1{

  var arr1 = Array("sheikh", "zaid", "bin", "shams") // Creates an Array[String]

  val arr2 = Array(1, 2, 3, 4) // Creates an Array[Int]

  val arr3 = Array.fill(5)(10)  // array of size 5, filled with 10

  def func(a: Int): Int = (a * a)

  val arr4 = Array.fill(5)(func(67)) // an array with function as input to Array address

  val arr5 = Array.tabulate(5)(i => i * i) // Compute within the array

  val arr6 = (1 to 5).toArray // creates an array from 1-5

  val arr7 = Array.ofDim[Int](3, 3) //  3x3 (2D array)

  val arr8 = Array.range(1, 5) // 1-4 since range is till 5

  val x = Array(1, 2)

  val y = Array(3, 4)

  val arr9 = Array.concat(x,y) // concatenates both arrays x and y

  val arr10 = Array.apply(1, 2, 3, 4) // another way to write an array


  def main(args: Array[String]): Unit = {
    println(arr1.mkString(", "))
    println(arr2.mkString(", "))
    println(arr3.mkString(", "))
    println(arr4.mkString(", "))
    println(arr5.mkString(", "))
    println(arr6.mkString(", "))
    arr7.foreach(row => println("|" + row.mkString(", ") + "|"))
    println(arr8.mkString(", "))
    println(arr9.mkString(", "))
    println(arr10.mkString(", "))
  }
}
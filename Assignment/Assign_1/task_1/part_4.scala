package task_1

//Exercise 4: In this session we saw some methods like .head and .tail that can be applied on Lists and Arrays.
//Some of these methods are called higher order methods and we can pass a function in these method as
//parameter. Explore the higher order methods available in scala for arrays. This will be helpful in doing task
//4 in assignments.

object part_4 {

  def main(args: Array[String]): Unit = {

    val arr = Array(1, 2, 3, 4, 5)
    val sqArr = arr.map(x => x * x) //this hof maps values along with optional operation
    println(sqArr.mkString(", "))

    val evenArr = arr.filter(x => x % 2 == 0) //this hof filters values in an array w.r.t the operation
    println(evenArr.mkString(", "))

    val sum1 = arr.reduce((a, b) => a + b) //operates on all array vales together giving single output
    println(sum1)

    val sum2 = arr.foldLeft(0)((acc, x) => acc + x) //performs operation starting from 0 from left to right
    println(sum2)

    arr.foreach(x => println(x)) // Prints each element //prints each index values individually

    val flatMappedArr = arr.flatMap(x => Array(x, x * 2)) //operates single index value depending upon the no.of.parameters
    println(flatMappedArr.mkString(", "))

    val arr1 = Array(1, 2, 3)
    val arr2 = Array("a", "b", "c")
    val zippedArr = arr1.zip(arr2) //zips two arrays as tupples
    println(zippedArr.mkString(", "))

    val (evens, odds) = arr.partition(x => x % 2 == 0) // seprates two an array into two or many depending on parameteric inputs
    println(evens.mkString(", "))
    println(odds.mkString(", "))

    val grouped = arr.groupBy(x => x % 2) //seprates two an array into two or many depending on outputs
    println(grouped(0).mkString(", "))
    println(grouped(1).mkString(", "))

    val found = arr.find( _ > 3)  // aka (x => x >3) locates index values by boolean operations 
    println(found) 
  }
}

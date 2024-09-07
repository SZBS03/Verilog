package task_2

import scala.util.Random

object part_1 {                         
  def random(x: Int): List[Int] = {               //function that creates a list of random numbers from 50-500 with max range of 15
    def f(a: Int, acc: List[Int]): List[Int] = {
      if (acc.length >= x) acc
      else f(a + Random.nextInt(70), acc :+ a)
    }

    f(50, List())
  }

  def partition_even_odd(i: List[Int]): (List[Int],List[Int]) = {       //separates even and odd lists into a separate list
    val (even, odd) = i.partition(x => x % 2 == 0)
    println(s"Even numbers: $even")
    println(s"Odd numbers $odd")
    (even,odd)
  }
  def sort_to_accending(x: List[Int]):Map[Int,Int] = {         //function that sorts any list to accending order with also having index as key that points to value
    val temp = x.sorted
    temp.zipWithIndex.map { (value, index) => (index, value) }.toMap
  }

  def main(args: Array[String]): Unit = {
    println(random(15))
    partition_even_odd(random(15))
    val sort = sort_to_accending(random(15))
    println(sort)
  }
}
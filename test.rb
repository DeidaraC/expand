require 'minitest/autorun'
require "open3"

class TestExpand < Minitest::Test
  CFLAGS = "-std=c99 -Wall"
  `cc #{CFLAGS} expand.c -o expand.out`

  def test_basic_usage
    stdout_str, stderr_str, status = Open3.capture3("./expand.out fixture/text1.txt")
    assert_equal IO.read("fixture/expanded_text1.txt"), stdout_str
    assert_equal 0, status.exitstatus
    assert_equal "", stderr_str

    stdout_str2, stderr_str2, status2 = Open3.capture3("./expand.out fixture/text2.txt")
    assert_equal IO.read("fixture/expanded_text2.txt"), stdout_str2
    assert_equal 0, status2.exitstatus
    assert_equal "", stderr_str2
  end

  def test_non_english
    stdout_str, stderr_str, status = Open3.capture3("./expand.out fixture/text3.txt")
    assert_equal IO.read("fixture/expanded_text3.txt"), stdout_str
    assert_equal 0, status.exitstatus
    assert_equal "", stderr_str
  end

  def test_option_t
    stdout_str, stderr_str, status = Open3.capture3("./expand.out -t 6 fixture/text1.txt")
    assert_equal IO.read("fixture/expanded_6_text1.txt"), stdout_str
    assert_equal 0, status.exitstatus
    assert_equal "", stderr_str

    stdout_str2, stderr_str2, status2 = Open3.capture3("./expand.out -t 6 fixture/text3.txt")
    assert_equal IO.read("fixture/expanded_6_text3.txt"), stdout_str2
    assert_equal 0, status2.exitstatus
    assert_equal "", stderr_str2
  end

  def test_option_tabs
    stdout_str, stderr_str, status = Open3.capture3("./expand.out --tabs=6 fixture/text1.txt")
    assert_equal IO.read("fixture/expanded_6_text1.txt"), stdout_str
    assert_equal 0, status.exitstatus
    assert_equal "", stderr_str

    stdout_str2, stderr_str2, status2 = Open3.capture3("./expand.out --tabs=6 fixture/text3.txt")
    assert_equal IO.read("fixture/expanded_6_text3.txt"), stdout_str2
    assert_equal 0, status2.exitstatus
    assert_equal "", stderr_str2
  end

  def test_wrong_option_t
    stdout_str5, stderr_str5, status5 = Open3.capture3("./expand.out")
    assert_equal "", stdout_str5
    assert_equal 1, status5.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str5

    stdout_str6, stderr_str6, status6 = Open3.capture3("./expand.out -t")
    assert_equal "", stdout_str6
    assert_equal 1, status6.exitstatus
    assert_equal "./expand.out: option requires an argument -- 't'\nUsage: expand [-t number] [file ...]\n", stderr_str6

    stdout_str, stderr_str, status = Open3.capture3("./expand.out -t i fixture/text1.txt")
    assert_equal "", stdout_str
    assert_equal 1, status.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str

    stdout_str2, stderr_str2, status2 = Open3.capture3("./expand.out -t -1 fixture/text1.txt")
    assert_equal "", stdout_str2
    assert_equal 1, status2.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str2

    stdout_str3, stderr_str3, status3 = Open3.capture3("./expand.out -t fixture/text1.txt")
    assert_equal "", stdout_str3
    assert_equal 1, status3.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str3

    stdout_str4, stderr_str4, status4 = Open3.capture3("./expand.out -e fixture/text1.txt")
    assert_equal "", stdout_str4
    assert_equal 1, status4.exitstatus
    assert_equal "./expand.out: invalid option -- 'e'\nUsage: expand [-t number] [file ...]\n", stderr_str4
  end

  def test_wrong_option_tabs
    stdout_str6, stderr_str6, status6 = Open3.capture3("./expand.out --tabs")
    assert_equal "", stdout_str6
    assert_equal 1, status6.exitstatus
    assert_equal "./expand.out: option '--tabs' requires an argument\nUsage: expand [-t number] [file ...]\n", stderr_str6

    stdout_str, stderr_str, status = Open3.capture3("./expand.out -tabs=i fixture/text1.txt")
    assert_equal "", stdout_str
    assert_equal 1, status.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str

    stdout_str2, stderr_str2, status2 = Open3.capture3("./expand.out --tabs=-1 fixture/text1.txt")
    assert_equal "", stdout_str2
    assert_equal 1, status2.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str2

    stdout_str3, stderr_str3, status3 = Open3.capture3("./expand.out --tabs fixture/text1.txt")
    assert_equal "", stdout_str3
    assert_equal 1, status3.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str3

    stdout_str4, stderr_str4, status4 = Open3.capture3("./expand.out -e fixture/text1.txt")
    assert_equal "", stdout_str4
    assert_equal 1, status4.exitstatus
    assert_equal "./expand.out: invalid option -- 'e'\nUsage: expand [-t number] [file ...]\n", stderr_str4
  end
end

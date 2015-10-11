require 'minitest/autorun'
require "open3"

class TestExpand < Minitest::Test
  CFLAGS = "-std=c99 -Wall"
  `cc #{CFLAGS} expand.c -o expand.out`

  def test_basic_usage
    stdout_str, stderr_str, status = Open3.capture3("./expand.out test_text/text1.txt")
    assert_equal IO.read("test_text/expanded_text1.txt"), stdout_str
    assert_equal 0, status.exitstatus
    assert_equal "", stderr_str

    stdout_str2, stderr_str2, status2 = Open3.capture3("./expand.out test_text/text2.txt")
    assert_equal IO.read("test_text/expanded_text2.txt"), stdout_str2
    assert_equal 0, status2.exitstatus
    assert_equal "", stderr_str2
  end

  def test_non_english
    stdout_str, stderr_str, status = Open3.capture3("./expand.out test_text/text3.txt")
    assert_equal IO.read("test_text/expanded_text3.txt"), stdout_str
    assert_equal 0, status.exitstatus
    assert_equal "", stderr_str
  end

  def test_option_t
    stdout_str, stderr_str, status = Open3.capture3("./expand.out -t 6 test_text/text1.txt")
    assert_equal IO.read("test_text/expanded_6_text1.txt"), stdout_str
    assert_equal 0, status.exitstatus
    assert_equal "", stderr_str

    stdout_str2, stderr_str2, status2 = Open3.capture3("./expand.out -t 6 test_text/text3.txt")
    assert_equal IO.read("test_text/expanded_6_text3.txt"), stdout_str2
    assert_equal 0, status2.exitstatus
    assert_equal "", stderr_str2
  end

  def test_wrong_option
    stdout_str5, stderr_str5, status5 = Open3.capture3("./expand.out")
    assert_equal "", stdout_str5
    assert_equal 1, status5.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str5

    stdout_str6, stderr_str6, status6 = Open3.capture3("./expand.out -t")
    assert_equal "", stdout_str6
    assert_equal 1, status6.exitstatus
    assert_equal "./expand.out: option requires an argument -- 't'\nUsage: expand [-t number] [file ...]\n", stderr_str6

    stdout_str, stderr_str, status = Open3.capture3("./expand.out -t i test_text/text1.txt")
    assert_equal "", stdout_str
    assert_equal 1, status.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str

    stdout_str2, stderr_str2, status2 = Open3.capture3("./expand.out -t -1 test_text/text1.txt")
    assert_equal "", stdout_str2
    assert_equal 1, status2.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str2

    stdout_str3, stderr_str3, status3 = Open3.capture3("./expand.out -t test_text/text1.txt")
    assert_equal "", stdout_str3
    assert_equal 1, status3.exitstatus
    assert_equal "Usage: expand [-t number] [file ...]\n", stderr_str3

    stdout_str4, stderr_str4, status4 = Open3.capture3("./expand.out -e test_text/text1.txt")
    assert_equal "", stdout_str4
    assert_equal 1, status4.exitstatus
    assert_equal "./expand.out: invalid option -- 'e'\nUsage: expand [-t number] [file ...]\n", stderr_str4
  end
end

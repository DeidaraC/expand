require 'minitest/autorun'

class TestExpand < Minitest::Test
  CFLAGS = "-std=c99 -Wall"
  `cc #{CFLAGS} expand.c -o expand.out`

  def test_basic_usage
    output1 = `./expand.out test_text/text1.txt`
    assert_equal `cat test_text/expanded_text1.txt`, output1

    output2 = `./expand.out test_text/text2.txt`
    assert_equal `cat test_text/expanded_text2.txt`, output2
  end

  def test_non_english
    output = `./expand.out test_text/text3.txt`
    assert_equal `cat test_text/expanded_text3.txt`, output
  end

  def test_option_t
    output1 = `./expand.out -t 6 test_text/text1.txt`
    output2 = `./expand.out test_text/text1.txt -t 6`
    assert_equal `cat test_text/expanded_6_text1.txt`, output1
    assert_equal `cat test_text/expanded_6_text1.txt`, output2

    output3 = `./expand.out -t 6 test_text/text3.txt`
    output4 = `./expand.out test_text/text3.txt -t 6`
    assert_equal `cat test_text/expanded_6_text3.txt`, output3
    assert_equal `cat test_text/expanded_6_text3.txt`, output4

  end
end

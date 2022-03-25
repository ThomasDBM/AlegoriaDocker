import unittest

class TestCreateMethods(unittest.TestCase):

    def test_test(self):
        self.assertEqual('foo'.upper(), 'FOO')

if __name__ == '__main__':
    unittest.main()
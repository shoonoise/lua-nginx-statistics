from urlparse import urljoin
import requests
import unittest
import time

HOST = "http://192.168.33.11"


class Base(unittest.TestCase):
    """
    ATTENTION: Test name define a target status
    """

    @staticmethod
    def _get_current_stat(name):
        reply = requests.get(urljoin(HOST, "status_stat"),
                             headers={'content-type': 'application/json'})
        return reply.json().get(name)

    def _check_counter(fn):
        """Make a little magic to avoid code duplication.
           This wrapper generate test based on test method's name """
        def wrapper(fn):
            status = fn._testMethodName.split("_")[-1]
            current = Base._get_current_stat(status)
            requests.get(urljoin(HOST, status), allow_redirects=False)
            time.sleep(1)
            new = Base._get_current_stat(status)
            unittest.TestCase.assertEqual(fn, new - current, 1,
                                          "Counter for status %s should be %s, but %s" % (status, current + 1, new))
        return wrapper

    @_check_counter
    def test_get_204(self):
        pass

    @_check_counter
    def test_get_500(self):
        pass

    @_check_counter
    def test_get_404(self):
        pass

    @_check_counter
    def test_get_302(self):
        pass

if __name__ == '__main__':
    unittest.main()

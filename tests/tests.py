from urlparse import urljoin
import requests
import unittest
import os
import json

HOST = "http://%s" % os.environ['WEB_PORT_80_TCP_ADDR']


class Base(unittest.TestCase):

    @staticmethod
    def _get_current_stat(stat_type):
        reply = requests.get(urljoin(HOST, "stat"),
                             headers={'content-type': 'application/json'})
        reply.raise_for_status()
        return json.loads(reply.content)[stat_type]

    def test_statuses(self):
        """Check statuses statistic."""
        locations = ["105", "204", "302", "404", "500"]

        for location in locations:
            current_statuses = Base._get_current_stat("status")
            status_class = "%sxx" % location[0]

            if current_statuses.get(location):
                current_counter = current_statuses[location][status_class]
            else:
                current_counter = 0
            total_counter = current_statuses['_total'][status_class]
            requests.get(urljoin(HOST, '%s' % location), allow_redirects=False)
            new_counter = Base._get_current_stat("status")[location][status_class]
            new_total = Base._get_current_stat("status")['_total'][status_class]

            self.assertEqual(new_counter - current_counter, 1)
            self.assertEqual(new_total - total_counter, 1)

    def test_delays(self):
        """Check timings statistic.
           Disclaimer:
           I believe there is no lag on local host.
           So, on some cases you can't trust this tests on 100%"""

        expected_delays = {'0': '0-100',
                           '02': '100-500',
                           '06': '500-1000',
                           '1': '1000-inf'}

        for location, delay in expected_delays.items():
            current_timings = Base._get_current_stat("timings")
            if current_timings.get(location):
                current_counter = current_timings[location][delay]
            else:
                current_counter = 0
            total_counter = current_timings['_total'][delay]
            requests.get(urljoin(HOST, '%s' % location))
            new_counter = Base._get_current_stat("timings")[location][delay]
            new_total = Base._get_current_stat("timings")['_total'][delay]

            self.assertEqual(new_counter - current_counter, 1)
            self.assertEqual(new_total - total_counter, 1)

if __name__ == '__main__':
    unittest.main()

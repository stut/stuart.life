from datetime import datetime
import json
import logging
import os
import requests

logging.getLogger().setLevel(logging.INFO)


class PatientViewClient(object):
    def __init__(self, username=None, password=None, api_key=None,
                 base_url='https://www.patientview.org/api',
                 cache_filename=None):
        self._username = os.environ.get('PV_USERNAME') if username is None else username
        self._password = os.environ.get('PV_PASSWORD') if password is None else password
        self._api_key = os.environ.get('PV_API_KEY') if api_key is None else api_key
        self._base_url = base_url.rstrip('/')
        self._cache_filename = os.environ.get('PV_CACHE_FILENAME') if cache_filename is None else cache_filename
        self._user = {'token': None, 'id': None}
        self._load_cache()

    def get_url(self, url, already_logged_in=False):
        logging.info('get_url: {0}'.format(url))
        if self._user['token'] is not None and self._user['id'] is not None:
            r = requests.get(
                url=self._make_url('user/{0}/{1}'.format(self._user['id'], url)),
                headers={'X-Auth-Token': self._user['token']},
            )

        if self._user['token'] is None or self._user['id'] is None or r.status_code == 401:
            if already_logged_in:
                raise Exception('Authentication failed!')
            self._login()
            return self.get_url(url, True)

        if r.status_code != 200:
            raise Exception('Request for {0} failed!'.format(url))
        return r.json()

    def _load_cache(self):
        if self._cache_filename is not None and os.path.exists(self._cache_filename):
            logging.info('load_cache')
            self._user = json.load(open(self._cache_filename, 'rt'))

    def _save_cache(self):
        if self._cache_filename is not None:
            logging.info('save_cache')
            json.dump(self._user, open(self._cache_filename, 'wt'))

    def _make_url(self, url):
        return '{0}/{1}'.format(self._base_url, url)

    def _login(self):
        logging.info('login')
        r = requests.post(
            url=self._make_url('auth/login'),
            json={
                'username': self._username,
                'password': self._password,
                'apiKey': self._api_key,
            }
        )
        if r.status_code != 200:
            raise Exception('Login failed')

        self._user['token'] = r.json()['token']
        r = requests.get(
            url=self._make_url('auth/{0}/basicuserinformation'.format(self._user['token'])),
            headers={'X-Auth-Token': self._user['token']},
        )
        if r.status_code != 200:
            raise Exception('Failed to get user information')

        self._user['id'] = r.json()['id']

        self._save_cache()


if __name__ == '__main__':
    target_dir = os.environ.get('PV_TARGET_DIR')
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    pvc = PatientViewClient()
    observations = pvc.get_url('availableobservationheadings')
    for observation in observations:
        obs = pvc.get_url('observations/{0}'.format(observation['code']))
        data = {
            'code': observation['code'],
            'name': observation['heading'],
            'units': observation['units'],
            'readings': [],
        }
        for ob in reversed(obs):
            if ob['group']['code'] != 'PATIENT_ENTERED' and ob['value'] != 'NoValue':
                data['readings'].append({
                    'date': datetime.utcfromtimestamp(int(ob['applies'] / 1000)).strftime('%Y-%m-%dT%H:%M:%SZ'),
                    'value': ob['value'],
                })
        if len(data['readings']) > 0:
            json.dump(data, open(os.path.join(target_dir, '{0}.json'.format(observation['code'])), 'wt'), sort_keys=True)

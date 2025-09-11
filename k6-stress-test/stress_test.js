import http from 'k6/http';
import { sleep } from 'k6';
import { htmlReport } from 'https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js';
import { textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';

export let options = {
  vus: 50,
  duration: '20s',
};

const TARGET = __ENV.TARGET;

export default function () {
  http.get(TARGET);
  sleep(1);
}

export function handleSummary(data) {
  return {
    '/k6-results/report.html': htmlReport(data),
    stdout: textSummary(data, { indent: '  ', enableColors: true }),
  };
}

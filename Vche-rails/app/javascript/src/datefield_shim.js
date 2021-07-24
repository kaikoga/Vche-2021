// @see https://gist.github.com/vielhuber/ec28574b616a81c55d6451271466716f
import 'flatpickr/dist/flatpickr.css';

import flatpickr from 'flatpickr';
import { ja } from 'flatpickr/dist/l10n/ja.js';

document.addEventListener('DOMContentLoaded', function() {
  flatpickr('input[type="datetime-local"]', {
    enableTime: true,
    altInput: true,
    allowInput: true,
    altFormat: 'Y/m/d(D) H:i',
    dateFormat: 'Y-m-dTH:i:S',
    locale: 'ja',
    time_24hr: true,
    /* bugfix: https://github.com/flatpickr/flatpickr/issues/2040 */
    onChange: function(selectedDates, dateStr, instance) {
      if (dateStr === '') {
        instance.close();
      }
    }
  });
});

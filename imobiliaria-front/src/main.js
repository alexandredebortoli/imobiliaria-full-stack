import 'bootstrap';
import 'bootstrap-icons/font/bootstrap-icons.css';

import Vue from 'vue';
import router from '@/router';

import '@/directives';
import '@/config/element-ui';
import '@/config/vee-validate';
import '@/config/biblioteca-components';

import App from '@/App.vue';

Vue.config.productionTip = false;

new Vue({
  router,
  render: h => h(App),
}).$mount('#app');

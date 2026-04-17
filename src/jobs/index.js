const afadJob = require('./afad.job');
const mgmJob = require('./mgm.job');
const ibbJob = require('./ibb.job');
const namazJob = require('./namaz.job');
const tcmbJob = require('./tcmb.job');

const initJobs = () => {
    afadJob.schedule();
    mgmJob.schedule();
    ibbJob.schedule();
    namazJob.schedule();
    tcmbJob.schedule();
    console.log('[Jobs] Bütün zamanlanmış görevler (cron jobs) başlatıldı.');
};

module.exports = initJobs;

exports.new = function(k) {
  return new Promise(k);
};

exports.then_ = function(k, p) {
  return p.then(k);
};

exports.catch  = function(k, p) {
  return p.catch(k);
};

exports.finally = function(k, p) {
  return p.finally(k);
};

exports.resolve = Promise.resolve;
exports.reject = Promise.reject;
exports.all = Promise.all;
exports.race = Promise.race;
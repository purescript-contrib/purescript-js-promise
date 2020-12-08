"use strict";

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

exports.resolve = function(a) {
  return Promise.resolve(a);
};

exports.reject = function(a) {
  return Promise.reject(a);
};

exports.all = function(a) {
  return Promise.all(a);
};

exports.race = function(a) {
  return Promise.race(a);
};

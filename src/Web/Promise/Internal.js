const newImpl = function (k) {
  return new Promise(k);
};
export { newImpl as new };

export function then_(k, p) {
  return p.then(k);
}

export function thenOrCatch(k, c, p) {
  return p.then(k, c);
}

const catchImpl = function (k, p) {
  return p.catch(k);
};
export { catchImpl as catch };

const finallyImpl = function (k, p) {
  return p.finally(k);
};
export { finallyImpl as finally };

export function resolve(a) {
  return Promise.resolve(a);
}

export function reject(a) {
  return Promise.reject(a);
}

export function all(a) {
  return Promise.all(a);
}

export function race(a) {
  return Promise.race(a);
}

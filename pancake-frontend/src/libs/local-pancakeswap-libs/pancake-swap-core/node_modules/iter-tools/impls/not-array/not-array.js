var isArray = Array.isArray;

function notArray(value) {
  return !isArray(value);
}

exports.notArray = notArray;
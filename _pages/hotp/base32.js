base32tohex = (function() {
    var dec2hex = function(s) {
        return (s < 15.5 ? "0" : "") + Math.round(s).toString(16)
    }, hex2dec = function(s) {
        return parseInt(s, 16)
    }, base32tohex = function(base32) {
        for (var base32chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567", bits = "", hex = [], i = 0; i < base32.length; i++) {
            var val = base32chars.indexOf(base32.charAt(i).toUpperCase());
            bits += leftpad(val.toString(2), 5, "0")
        }
        for (i = 0; i + 8 <= bits.length; i += 8) {
            var chunk = bits.substr(i, 8);
            hex.push(parseInt(chunk, 2))
        }
        return hex
    }, leftpad = function(str, len, pad) {
        return len + 1 >= str.length && (str = new Array(len + 1 - str.length).join(pad) + str),
        str
    };
    return base32tohex;
}
)()

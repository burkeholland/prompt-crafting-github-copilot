/* this file extends the string prototype...
1. reverse - reverses a string
2. capitalizeFirstLetter - capitalizes the first letter of a string
3. removeHTMLTags - removes HTML tags from a string
*/

interface String {
    reverse(): string;
    capitalizeFirstLetter(): string;
    removeHTMLTags(): string;
}

String.prototype.reverse = function () {
    return this.split('').reverse().join('');
}

String.prototype.capitalizeFirstLetter = function () {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

String.prototype.removeHTMLTags = function () {
    return this.replace(/<[^>]*>/g, '');
}
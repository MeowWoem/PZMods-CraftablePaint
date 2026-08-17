CPEUtils = CPEUtils or {};

local badColor = getCore():getBadHighlitedColor();

function CPEUtils.addBadText(character, message, duration) {
    duration = duration or 400;
    character:setHaloNote(message, badColor:getR() * 255, badColor:getG() * 255, badColor:getB() * 255, duration);
}
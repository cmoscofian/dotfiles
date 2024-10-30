const spotify = Application('Spotify');
const music = Application('Music');

let output;

if (spotify.running()) {
    output = getSongString(spotify);
} else if (music.running()) {
    output = getSongString(music);
}

output;

function getSongString(application) {
    const song = application.currentTrack.name().slice(0, 30);
    const artist = application.currentTrack.artist().slice(0, 25);
    return `${song} - ${artist}, `;
}

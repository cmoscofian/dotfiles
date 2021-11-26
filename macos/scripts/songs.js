const spotify = Application("Spotify");
const music = Application("Music");

let output;

if (spotify.running()) {
  output = getSongString(spotify);
} else if (music.running()) {
  output = getSongString(music);
}

output;

function getSongString(application) {
  return `" ${application.currentTrack.name()} - ${application.currentTrack.artist()}`.substr(0, 50);
}

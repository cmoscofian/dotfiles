const spotify = Application("Spotify");
let output = "";

if (spotify.running()) {
  output = `" ${spotify.currentTrack.name()} - ${spotify.currentTrack.artist()}`.substr(0, 50)
}

output;

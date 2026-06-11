extends Node

enum SFX {
    CLOCK_UP,
    CLOCK_DOWN,
    ALARM,
    LAMP_SWITCH
}

enum MUSIC {
    DEFAULT
}

const SFX_ID_META := "sfx_id"
const MUSIC_ID_META := "music_id"

var _sfx_streams := {
    SFX.CLOCK_UP: preload("res://assets/sfx/ClockUp.wav"),
    SFX.CLOCK_DOWN: preload("res://assets/sfx/ClockDown.wav"),
    SFX.ALARM: preload("res://assets/sfx/Alarm.mp3"),
    SFX.LAMP_SWITCH: preload("res://assets/sfx/LampSwitch.ogg"),
}

var _music_streams := {

}

@onready var music_player := AudioStreamPlayer.new()
@onready var sfx_pool: Array[AudioStreamPlayer] = []

var pool_size = 8

func _ready():
    add_child(music_player)
    music_player.bus = "Music"

    for i in range(pool_size):
        var sfx_player = AudioStreamPlayer.new()
        sfx_player.bus = "SFX"
        add_child(sfx_player)
        sfx_pool.append(sfx_player)


## ! IMPORTANT: only loops if sfx is MP3 or OGG
func play_sfx(sfx: SFX, loop: bool = false):
    if sfx not in _sfx_streams:
        push_error("SFX not found: %s" % sfx)
        return
    
    var sound: AudioStream = _sfx_streams[sfx]
    if loop and (sound is AudioStreamMP3 or sound is AudioStreamOggVorbis):
        sound.loop = true

    var sfx_player: AudioStreamPlayer = _get_sfx_player()
    sfx_player.stream = sound
    sfx_player.set_meta(SFX_ID_META, sfx)
    sfx_player.play()


func stop_sfx(sfx: SFX):
    for player in sfx_pool:
        if player.playing and player.get_meta(SFX_ID_META, -1) == sfx:
            player.stop()
            player.stream = null
            player.remove_meta(SFX_ID_META)
            return


func play_music(music: MUSIC):
    if music not in _music_streams:
        push_error("Song not found: %s" % music)
        return

    var song: AudioStream = _music_streams[music]
    if song is AudioStreamMP3:
        (song as AudioStreamMP3).loop = true
    
    music_player.stream = song
    music_player.set_meta(MUSIC_ID_META, music)
    music_player.play()


func stop_music():
    music_player.stop()
    music_player.stream = null
    music_player.remove_meta(MUSIC_ID_META)


func _get_sfx_player() -> AudioStreamPlayer:
    for sfx_player in sfx_pool:
        if not sfx_player.playing:
            return sfx_player

    return sfx_pool[0]
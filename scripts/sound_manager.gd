extends Node

enum SFX {
    CLOCK_UP,
    CLOCK_DOWN,
    ALARM,
}

enum MUSIC {
    DEFAULT
}

var _sfx_streams := {
    SFX.CLOCK_UP: preload("res://assets/sfx/ClockUp.wav"),
    SFX.CLOCK_DOWN: preload("res://assets/sfx/ClockDown.wav"),
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


func play_sfx(sfx: SFX):
    if sfx not in _sfx_streams:
        push_error("SFX not found: %s" % sfx)
        return
    
    var sfx_player: AudioStreamPlayer = _get_sfx_player()
    sfx_player.stream = _sfx_streams[sfx]
    sfx_player.play()


func play_music(music: MUSIC):
    if music not in _music_streams:
        push_error("Song not found: %s" % music)
        return

    var song: AudioStream = _music_streams[music]
    if song is AudioStreamMP3:
        (song as AudioStreamMP3).loop = true
    
    music_player.stream = song
    music_player.play()

func _get_sfx_player() -> AudioStreamPlayer:
    for sfx_player in sfx_pool:
        if not sfx_player.playing:
            return sfx_player

    return sfx_pool[0]
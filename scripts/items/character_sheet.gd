extends Node2D

@export_category("Client Properties")
@export var client_name = ""
@export var client_age = ""
@export var client_sex = ""

@export_category("Request Properties")
@export var bargain = ""
@export var sacrifice = ""

@export_category("Client Details")
@export var organ = ""
@export var astral_sign = ""
@export var death = ""
@export var ethics = ""
@export var ambition = ""
@export var nightmare = ""
@export var correct_patron = ""

@onready var name_label = $Name/Content
@onready var age_label = $Age/Content
@onready var sex_label = $Sex/Content
@onready var bargain_label = $Bargain/Content
@onready var sacrifice_label = $Sacrifice/Content
@onready var organ_label = $Organ/Content
@onready var sign_label = $Sign/Content
@onready var death_label = $Death/Content
@onready var ethics_label = $Ethics/Content
@onready var ambition_label = $Ambition/Content
@onready var nightmare_label = $Nightmare/Content
@onready var stampable = $Stampable


func _ready() -> void:
	name_label.text = client_name
	age_label.text = client_age
	sex_label.text = client_sex
	bargain_label.text = bargain
	sacrifice_label.text = sacrifice
	organ_label.text = organ
	sign_label.text = astral_sign
	death_label.text = death
	ethics_label.text = ethics
	ambition_label.text = ambition
	nightmare_label.text = nightmare
	stampable.correct_stamp = correct_patron

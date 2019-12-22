extends Node

"""
	Handles all comunications with Newgrounds.
"""

signal free

var is_connected = false
var ping_interval = 0
var _result = null
var busy = false

var medals_data = {
	58580:false, #killed a banana
	58581:false, #killed a brocc
	58582:false, #killed a tomato
	58579:false, #beat the game
	58583:false  #debug medal
}

func init(ping_interval):
	self.ping_interval = ping_interval
	if not is_connected:
		$Ping.wait_time = ping_interval
		$Ping.start()
		check_connection()
	
func check_connection():
	busy = true
	$NewGroundsAPI.App.checkSession()
	_result = yield($NewGroundsAPI, 'ng_request_complete')
	if $NewGroundsAPI.is_ok(_result):
		print(str(_result.response))
		is_connected = true
	else:
		print(_result.error)
		is_connected = false
	busy = false
	emit_signal("free")
	
	
func renew_id():
	busy = true
	if is_connected:
		$NewGroundsAPI.Gateway.ping()
		_result = yield($NewGroundsAPI, 'ng_request_complete')
		if $NewGroundsAPI.is_ok(_result):
			print(str(_result.response))
			is_connected = true
		else:
			print(_result.error)
			is_connected = false
	busy = false
	emit_signal("free")

func add_score(score):
	if not is_connected: return
	
	$NewGroundsAPI.ScoreBoard.postScore(score,8813)
	_result = yield($NewGroundsAPI, 'ng_request_complete')
	if $NewGroundsAPI.is_ok(_result):
		print(str(_result.response))
		is_connected = true
	else:
		print(_result.error)
		is_connected = false

func get_score(target):
	if busy: yield(self,"free")
	var final_list = {'names':[],'points':[]}
	var target_ref = weakref(target)
	#if not is_connected: 
	#	target.table = final_list
	#	return
	#scoreId, sessionId=api.session_id, limit=10, skip=0, social=false, tag=null, period=null, userId=null
	
	$NewGroundsAPI.ScoreBoard.getScores(8813,$NewGroundsAPI.session_id,5,0,false,null,'A')
	_result = yield($NewGroundsAPI, 'ng_request_complete')
	if $NewGroundsAPI.is_ok(_result) and target_ref.get_ref() != null:
		for id in range(_result.response['scores'].size()):
			final_list['names'].insert(id,_result.response['scores'][id]['user']['name'])
			final_list['points'].insert(id,_result.response['scores'][id]['formatted_value'])
		
		
		is_connected = true
		target.table = final_list
		print(final_list)
		return 
	else:
		is_connected = false
		return final_list

func unlock_medal(id):
	if busy: yield(self,'free')
	if not is_connected: return
	$NewGroundsAPI.Medal.unlock(id)
	_result = yield($NewGroundsAPI, 'ng_request_complete')
	if $NewGroundsAPI.is_ok(_result):
		print(str(_result.response))
		is_connected = true
	else:
		print(_result.error)
		is_connected = false














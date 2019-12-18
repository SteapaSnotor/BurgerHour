extends Node

"""
	Handles all comunications with Newgrounds.
"""

var is_connected = false
var ping_interval = 0
var _result = null

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
	$NewGroundsAPI.App.checkSession()
	_result = yield($NewGroundsAPI, 'ng_request_complete')
	if $NewGroundsAPI.is_ok(_result):
		print(str(_result.response))
		is_connected = true
	else:
		print(_result.error)
		is_connected = false
	
	
func renew_id():
	if is_connected:
		$NewGroundsAPI.Gateway.ping()
		_result = yield($NewGroundsAPI, 'ng_request_complete')
		if $NewGroundsAPI.is_ok(_result):
			print(str(_result.response))
			is_connected = true
		else:
			print(_result.error)
			is_connected = false

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
	var final_list = {'names':[],'points':[]}
	#if not is_connected: 
	#	target.table = final_list
	#	return
	
	$NewGroundsAPI.ScoreBoard.getScores(8813,$NewGroundsAPI.session_id,5)
	_result = yield($NewGroundsAPI, 'ng_request_complete')
	if $NewGroundsAPI.is_ok(_result):
		
		for id in range(_result.response['scores'].size()):
			final_list['names'].insert(id,_result.response['scores'][0]['user']['name'])
			final_list['points'].insert(id,_result.response['scores'][0]['formatted_value'])
		
		is_connected = true
		target.table = final_list
		return 
	else:
		is_connected = false
		return final_list

func unlock_medal(id):
	if not is_connected: return
	$NewGroundsAPI.Medal.unlock(id)
	_result = yield($NewGroundsAPI, 'ng_request_complete')
	if $NewGroundsAPI.is_ok(_result):
		print(str(_result.response))
		is_connected = true
	else:
		print(_result.error)
		is_connected = false














/*
	modify form Games With Go EP 05 - Text Adventure, Graphs!
	https://www.twitch.tv/jackmott42
*/
module main

import os

struct Pagenode {
	text    string
mut:
	choices &Choices
}

struct Choices {
	cmd         string
	description string
mut:
	next_node   &Pagenode
	next_choice &Choices
}

fn new_page(text string) &Pagenode {
	page := &Pagenode{
		text,0}
	return page
}

fn (node mut Pagenode) add_choice(cmd string, description string, next_node &Pagenode) {
	choice := &Choices{
		cmd,description,next_node,0}
	if node.choices == 0 {
		node.choices = choice
	}
	else {
		mut current_choice := node.choices
		for current_choice.next_choice != 0 {
			current_choice = current_choice.next_choice
		}
		current_choice.next_choice = choice
	}
}

fn (node Pagenode) render() {
	println(node.text)
	mut current_choice := node.choices
	for current_choice != 0 {
		println(current_choice.cmd + ' : ' + current_choice.description)
		current_choice = current_choice.next_choice
	}
}

fn (node Pagenode) execute_cmd(cmd string) Pagenode {
	mut current_choice := node.choices
	for current_choice != 0 {
		if current_choice.cmd.to_lower() == cmd.to_lower() {
			return current_choice.next_node
		}
		current_choice = current_choice.next_choice
	}
	println("選個我看的懂的啦！")
	return node
}

fn (node Pagenode) play() {
	node.render()
	mut cmd := ''
	if node.choices != 0 {
		for cmd.len < 1 {
			cmd = os.get_line().trim_space()
		}
		node.execute_cmd(cmd).play()
	}
}

fn main() {
	println("小白的冒險")
	mut star := new_page("
	嗯…一張開眼，你發現你在一個小小小的房間裏，昏暗的燈光下你看到有3個門…
	驚不驚喜！！！
	要不要開開看？
	PS：不開就等著餓死吧！")
	mut dark_room := new_page("伸手不見5指的房間")
	mut dark_room_lit := new_page('有點小小亮光的房間')
	grue := new_page("就是一個房間")
	trap := new_page("哈一個該的陷阱！你死了。")
	treasure := new_page("出○")
	star.add_choice('N', "北門", dark_room)
	star.add_choice('S', "南門", dark_room)
	star.add_choice('E', "東門", trap)
	dark_room.add_choice('S', "退回南門", grue)
	dark_room.add_choice('O', "點亮臘燭！", dark_room_lit)
	dark_room_lit.add_choice('N', "走北門", treasure)
	dark_room_lit.add_choice('S', "走南門", star)
	star.play()
	println("結束了？？？")
}

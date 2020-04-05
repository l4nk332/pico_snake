pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
cartdata("ij_snake")

hi_score_p = {8,9,10,11,12}

function init_state()
  mdir = "d"
  snake={}
  for i=64,54,-1 do add(snake, {64, i}) end
  fruit=rnd_coord()
  is_playing = true
  score = 0
  hi_score = dget(0) or 0
end

function _init()
  init_state()
end

function rnd_coord()
  return {
    flr(rnd(125) + 1),
    flr(rnd(115) + 1)
  }
end

function next_head()
  local x = snake[1][1]
  local y = snake[1][2]

  if (mdir == "l") then
    x -= 1
  elseif (mdir == "r") then
    x += 1
  elseif (mdir == "u") then
    y -= 1
  elseif (mdir == "d") then
    y += 1
  end

  return {x, y}
end

function update_snake(is_growing)
  local new_snake = {next_head()}

  if (is_growing) then
    for s in all(snake) do
      add(new_snake, s)
    end
  else
    for i=2,#snake do
      new_snake[i] = snake[i - 1]
    end
  end

  snake = new_snake
end

function draw_snake(is_growing)
  for c=1,#snake do
    local s_color = 3
    if (is_growing and c == #snake) then s_color = 11 end
    rectfill(snake[c][1], snake[c][2], snake[c][1]+1, snake[c][2]+1, s_color)
  end
end

function draw_fruit()
  rectfill(fruit[1], fruit[2], fruit[1] + 1, fruit[2] + 1, 8)
end

function _update()
  if (btn(0) and mdir != "r") then
    mdir = "l"
  elseif (btn(1) and mdir != "l") then
    mdir = "r"
  elseif (btn(2) and mdir != "d") then
    mdir = "u"
  elseif (btn(3) and mdir != "u") then
    mdir = "d"
  elseif (btn(5) and not is_playing) then
    init_state()
  end
end

function hcenter(s)
  return 64-#s*2
end

function vcenter()
  return 61
end

function new_hi_score()
  dset(0, score)
  local hs_msg = "new hi-score"

  for c=#hi_score_p, 1, -1 do
    print(hs_msg, hcenter(hs_msg)-c, 30+c, hi_score_p[c])
  end

  print(hs_msg, hcenter(hs_msg)-1, 31, 8)
  print(hs_msg, hcenter(hs_msg), 30, 7)

  local head = hi_score_p[1]
  del(hi_score_p, head)
  add(hi_score_p, head)
end

function losing_sfx()
  if (score < hi_score) then
    sfx(2)
  else
    sfx(1)
  end
end

function game_over()
  local g_msg = "game over - "
  local score_msg = "score: "..score
  local replay_msg = "press x to replay"

  if (score > hi_score) then
    print(score_msg, hcenter(score_msg), 45, 7)
    new_hi_score()
  else
    print(g_msg..score_msg, hcenter(g_msg..score_msg), 45, 7)
  end
  print(replay_msg, hcenter(replay_msg, 7), 64)
end

function check_bounds()
  if (snake[1][1] < 1 or snake[1][1] > 125 or snake[1][2] < 1 or snake[1][2] > 115) then
    is_playing = false
    losing_sfx()
  end
end

function check_fruit()
  local check = is_collision(snake[1], fruit)
  if (check) then
    fruit = rnd_coord()
    score += 1
    sfx(3)
  end

  return check
end

function check_snake_collision()
  local head = snake[1]

  for t=2,#snake do
    if (head[1] == snake[t][1] and head[2] == snake[t][2]) then
      is_playing = false
      losing_sfx()
      break
    end
  end
end

function is_collision(p1, p2)
-- this fn assumes that the
-- points pertain to rects
-- which are 1x1
  local p1_r_of_p2 = p1[1] > p2[1]+1
  local p1_l_of_p2 = p1[1]+1 < p2[1]
  local p1_t_of_p2 = p1[2] > p2[2]+1
  local p1_b_of_p2 = p1[2]+1 < p2[2]

  return not(p1_r_of_p2 or p1_l_of_p2 or p1_t_of_p2 or p1_b_of_p2)
end

function draw_footer()
  print("score: "..score, 2, 120, 7)
  print("hi-score: "..hi_score, 80, 120, 7)
end

function _draw()
  cls()

  if (is_playing) then
    rect(0,0,127,117,7)

    draw_fruit()

    check_bounds()
    local is_growing = check_fruit()
    check_snake_collision()

    update_snake(is_growing)
    draw_snake(is_growing)
    draw_footer()
  else
    game_over()
  end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010300000a5150c5150f515125251452515535175351a5351d5251f5251f515225052350524505245051b5051c5051d5051e50520505285052a5052c505215052250523505245052550525505265052750528505
000c00001c5551a555175551c5551a555175551c5551a555175551c5551a555175551c5551a555175521755217552175521755217552175521755217555005050050500505005050050500505005050050500000
010f0000100550f0550e0550d05500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
000500000d7110e7210f7211073111731127311472116721187111871100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701007010070100701
__music__
01 02434344
02 03424344


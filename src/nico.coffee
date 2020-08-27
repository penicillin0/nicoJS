class nicoJS
	constructor: (params) ->
		@version = '1.2.4'

		@timer    = null
		@interval = null
		@fps      = 1000 / 30
		@step     = 2 * 1000
		@comments = []

		@app       = params.app
		@font_size = params.font_size || 50
		@color     = params.color     || '#fff'
		@width     = params.width     || 500
		@height    = params.height    || 300
		@speed     = params.speed     || 4
		@band_list = shuffle [0...Math.floor(@height / @font_size)]
		@band_index = 0

		# 描画
		@render()

	##
	# 描画
	##
	render: ->
		@app.style.whiteSpace = 'nowrap'
		@app.style.overflow   = 'hidden'
		@app.style.position   = 'relative'
		@app.style.width      = @width  + 'px'
		@app.style.height     = @height + 'px'

		console.log 'nicoJS@' + @version
		console.log ' ├─ author     : yuki540'
		console.log ' ├─ homepage   : http://yuki540.com'
		console.log ' └─ repository : https://github.com/yuki540net/nicoJS'

	##
	# サイズ変更
	# @param width  : 幅
	# @param height : 高さ
	##
	resize: (width, height) ->
		@width            = width
		@height           = height
		@app.style.width  = @width + 'px'
		@app.style.height = @height + 'px'

	##
	# コメントを送信
	# @param text      : コメント
	# @param color     : 色[option]
	# @param font_size : フォントサイズ[option]
	##
	send: (params) ->
		console.log(params)
		text      = params.text      || ''
		color     = params.color     || @color
		font_size = params.size      || @font_size
		speed     = params.speed     || @speed
		x         = @width
		colum_height = Math.floor((@height - @font_size) / @band_list.length)
		y         =  @band_list[@band_index] *  colum_height
		ele       = document.createElement 'div'
		@band_index = (@band_index + 1) % @band_list.length

		ele.innerHTML        = text
		ele.style.position   = 'absolute'
		ele.style.left       = x + 'px'
		ele.style.top        = y + 'px'
		ele.style.fontSize   = font_size + 'px'
		ele.style.textShadow = '0 0 5px #111'
		ele.style.color      = color

		@app.appendChild ele
		@comments.push { ele: ele, x: x, y: y, speed: speed, dflg: 0 }

	##
	# コメントを流す
	##
	flow: ->
		len = @comments.length

		for i in [0...len]
			end = @comments[i].ele.getBoundingClientRect().width * -1
			if @comments[i].x >= end
				@comments[i].x -= @comments[i].speed
				@comments[i].ele.style.left = @comments[i].x + 'px'
			if @comments[i].x < end & @comments[i].dflg == 0
				# @appから流れ終わったコメントのdomを削除
				@app.removeChild @comments[i].ele
				@comments[i].dflg = 1

	##
	# コメントを待機
	##
	listen: ->
		@stop()

		@timer = setInterval =>
			@flow()
		, @fps

	##
	# 特定のコメントを流し続ける
	# @param comments : コメントが入った配列
	##
	loop: (comments) ->
		i   = 0
		len = comments.length

		@listen()

		@send comments[i++]
		@interval = setInterval =>
			if len < i then i = 0

			@send comments[i++]
		, @step

	##
	# アニメーション停止
	##
	stop: ->
		clearInterval @timer
		clearInterval @interval

try
	module.exports = nicoJS
catch e

# arrayをシャッフルする関数
shuffle = (array) ->
  i = array.length
  if i is 0 then return array
  while --i
    j = Math.floor Math.random() * (i + 1)
    tmpi = array[i]
    tmpj = array[j]
    array[i] = tmpj
    array[j] = tmpi
  return array
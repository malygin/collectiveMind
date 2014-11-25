# * Depends on jquery.ui.core, jquery.ui.widiget, jquery.ui.effect
# TODO: implement destroy()

(($) ->
  $.widget "ui.chatbox",
    options:
      id: null #id for the DOM element
      title: null # title of the chatbox
      user: null # can be anything associated with this chatbox
      hidden: false
      offset: 0 # relative to right edge of the browser window
      width: 300 # width of the chatbox
      messageSent: (id, user, msg) ->

        # override this
        @boxManager.addMsg user.first_name, msg
        return

      boxClosed: (id) ->

        # called when the close icon is clicked
      boxManager:
      # thanks to the widget factory facility
      # similar to http://alexsexton.com/?p=51
        init: (elem) ->
          @elem = elem
          return

        addMsg: (data, highlight = true, append = true, scroll = true) ->
          self = this
          box = self.elem.uiChatboxLog
          currentDate = new Date()
          lastSeenTime = new Date($('#last_seen_at').text().trim())
          time = new Date(data['time'])
          e = document.createElement("div")
          $(e).attr('id', data['id'])
          if time > lastSeenTime && $('#current_user_name').text().trim() != data['user'].trim()
            $('.ui-widget-header').addClass('ui-state-active')
            $(e).addClass('unreaded')
            $(e).mouseenter ->
              $(this).removeClass('unreaded')
              $('.ui-widget-header').removeClass('ui-state-active')
              $('title').text($('#old_title_page').text())

          if append
            box.append e
          else
            box.prepend e
          $(e).hide()

          timeString = ''
          if (currentDate.getDate()) > time.getDate()
            timeString += time.getDate() + '.' + time.getMonth() + ' '
          timeString += time.getHours() + ':' + time.getMinutes() + ':' + time.getSeconds()
          timeText = document.createElement('span')
          $(timeText).addClass('time').text timeString + " "

          systemMessage = false
          if data['user']
            peerName = document.createElement("b")
            $(peerName).addClass("text-lifetape").text data['user'] + " "
            e.appendChild timeText
            e.appendChild peerName
          else
            systemMessage = true

          msgElement = document.createElement((if systemMessage then "i" else "span"))
          $(msgElement).text data['text']
          e.appendChild msgElement
          $(e).addClass "ui-chatbox-msg"
          $(e).css "maxWidth", $(box).width()
          $(e).fadeIn()

          if scroll
            self._scrollToBottom()
          if not self.elem.uiChatboxTitlebar.hasClass("ui-state-focus") and not self.highlightLock and highlight
            self.highlightLock = true
            self.highlightBox()
          return

        highlightBox: ->
          self = this
          self.elem.uiChatboxTitlebar.effect "highlight", {}, 300
          self.elem.uiChatbox.effect "bounce",
            times: 3
          , 300, ->
            self.highlightLock = false
            self._scrollToBottom()
            return

          return

        toggleBox: ->
          @elem.uiChatbox.toggle()
          return

        _scrollToBottom: ->
          box = @elem.uiChatboxLog
          box.scrollTop box.get(0).scrollHeight
          return

    toggleContent: (event) ->
      @uiChatboxContent.toggle()
      @uiChatboxInputBox.focus()  if @uiChatboxContent.is(":visible")
      return

    widget: ->
      @uiChatbox

    _create: ->
      self = this
      options = self.options
      title = options.title or "No Title"

      # chatbox

      # ui-state-highlight is not really helpful here
      #self.uiChatbox.removeClass('ui-state-highlight');
      uiChatbox = (self.uiChatbox = $("<div></div>")).appendTo(document.body).addClass("ui-widget " + "ui-corner-top " + "ui-chatbox").attr("outline",
        0).focusin(->
        self.uiChatboxTitlebar.addClass "ui-state-focus"
        return
      ).focusout(->
        self.uiChatboxTitlebar.removeClass "ui-state-focus"
        return
      )

      # titlebar
      # take advantage of dialog header style

      #self.toggleContent(event);
      uiChatboxTitlebar = (self.uiChatboxTitlebar = $("<div></div>")).addClass("ui-widget-header " + "ui-corner-top " + "ui-chatbox-titlebar " + "ui-dialog-header").click((event) ->
      ).appendTo(uiChatbox)
      uiChatboxTitle = (self.uiChatboxTitle = $("<span></span>")).html(title).appendTo(uiChatboxTitlebar)
      uiChatboxTitlebarClose = (self.uiChatboxTitlebarClose = $("<a href=\"#\"></a>")).addClass("ui-corner-all " + "ui-chatbox-icon ").attr("role",
        "button").hover(->
        uiChatboxTitlebarClose.addClass "ui-state-hover"
        return
      , ->
        uiChatboxTitlebarClose.removeClass "ui-state-hover"
        return
      ).click((event) ->
        uiChatbox.hide()
        self.options.boxClosed self.options.id
        false
      ).appendTo(uiChatboxTitlebar)
      uiChatboxTitlebarCloseText = $("<span></span>").addClass("ui-icon " + "ui-icon-closethick").text("close").appendTo(uiChatboxTitlebarClose)
      uiChatboxTitlebarMinimize = (self.uiChatboxTitlebarMinimize = $("<a href=\"#\"></a>")).addClass("ui-corner-all " + "ui-chatbox-icon").attr("role",
        "button").hover(->
        uiChatboxTitlebarMinimize.addClass "ui-state-hover"
        return
      , ->
        uiChatboxTitlebarMinimize.removeClass "ui-state-hover"
        return
      ).click((event) ->
        self.toggleContent event
        false
      ).appendTo(uiChatboxTitlebar)
      uiChatboxTitlebarMinimizeText = $("<span></span>").addClass("ui-icon " + "ui-icon-minusthick").text("minimize").appendTo(uiChatboxTitlebarMinimize)

      # content
      uiChatboxContent = (self.uiChatboxContent = $("<div></div>")).addClass("ui-widget-content " + "ui-chatbox-content ").appendTo(uiChatbox)
      uiChatboxLog = (self.uiChatboxLog = self.element).addClass("ui-widget-content " + "ui-chatbox-log").appendTo(uiChatboxContent)

      # anything?
      uiChatboxInput = (self.uiChatboxInput = $("<div></div>")).addClass("ui-widget-content " + "ui-chatbox-input").click((event) ->
      ).appendTo(uiChatboxContent)
      uiChatboxInputBox = (self.uiChatboxInputBox = $("<textarea></textarea>")).addClass("ui-widget-content " + "ui-chatbox-input-box " + "ui-corner-all").appendTo(uiChatboxInput).keydown((event) ->
        if event.keyCode and event.keyCode is $.ui.keyCode.ENTER
          msg = $.trim($(this).val())
          self.options.messageSent self.options.id, self.options.user, msg  if msg.length > 0
          $(this).val ""
          false
      ).focusin(->
        uiChatboxInputBox.addClass "ui-chatbox-input-focus"
        box = $(this).parent().prev()
        box.scrollTop box.get(0).scrollHeight
        return
      ).focusout(->
        uiChatboxInputBox.removeClass "ui-chatbox-input-focus"
        return
      )

      # disable selection
      uiChatboxTitlebar.find("*").add(uiChatboxTitlebar).disableSelection()

      # switch focus to input box when whatever clicked
      uiChatboxContent.children().click ->


        # click on any children, set focus on input box
        #self.uiChatboxInputBox.focus();
      self._setWidth self.options.width
      self._position self.options.offset
      self.options.boxManager.init self
      uiChatbox.show()  unless self.options.hidden
      return

    _setOption: (option, value) ->
      if value?
        switch option
          when "hidden"
            if value
              @uiChatbox.hide()
            else
              @uiChatbox.show()
          when "offset"
            @_position value
          when "width"
            @_setWidth value
      $.Widget::_setOption.apply this, arguments
      return

    _setWidth: (width) ->
      @uiChatboxTitlebar.width width + "px"
      @uiChatboxLog.width width + "px"
      @uiChatboxInput.css "maxWidth", width + "px"

      # padding:2, boarder:2, margin:5
      @uiChatboxInputBox.css "width", (width - 18) + "px"
      return

    _position: (offset) ->
      @uiChatbox.css "right", offset
      return

  return) jQuery

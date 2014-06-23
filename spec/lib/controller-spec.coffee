
describe 'Controller', ->

  Given -> @Message = requireSubject 'lib/message', { }
  Given -> @Controller = requireSubject 'lib/controller', { './message': @Message }
  Then -> expect(typeof @Controller).toBe 'function'

  describe '#(message:Message)', ->

    Given -> @message = @Message()
    Given -> @controller = @Controller @message
    Then -> expect(@controller instanceof @Controller).toBe true
    And -> expect(@controller.message).toEqual @message
    And -> expect(@controller.data).toEqual @message.data

  describe 'prototype', ->

    Given -> @data =
      actor: 'me'
      target: 'you'
      content: 'hello'
      action: 'say'
      id: 1
    Given -> @message = @Message @data
    Given -> @controller = @Controller @message
    Given -> spyOn(@controller,'emit').andCallThrough()

    describe '#consume', ->

      When -> @controller.consume()
      Then -> expect(@controller.emit).toHaveBeenCalledWith 'consume', @message
      And -> expect(@message.consumed instanceof Date).toBe true


    describe '#respond (content:Mixed="goodbye")', ->

      When -> @controller.respond 'goodbye'
      Then -> expect(@controller.emit).toHaveBeenCalled()
      And -> expect(@controller.emit.mostRecentCall.args[0]).toBe 'respond'
      And -> expect(@controller.emit.mostRecentCall.args[1].actor()).toBe 'you'
      And -> expect(@controller.emit.mostRecentCall.args[1].action()).toBe 'say'
      And -> expect(@controller.emit.mostRecentCall.args[1].content()).toBe 'goodbye'
      And -> expect(@controller.emit.mostRecentCall.args[1].target()).toBe 'me'
      And -> expect(@controller.emit.mostRecentCall.args[1].reference()).toBe 1
      And -> expect(@controller.emit.mostRecentCall.args[1].created() instanceof Date).toBe true
      And -> expect(@controller.message.responded instanceof Date).toBe true

    describe '#deliver', ->

      When -> @controller.deliver()
      Then -> expect(@controller.emit).toHaveBeenCalledWith 'deliver', @message
      And -> expect(@controller.message.delivered instanceof Date).toBe true

    describe '#deliver (target:String="people")', ->

      Given -> @m = @message.clone()
      When -> @controller.deliver 'people'
      Then -> expect(@controller.emit).toHaveBeenCalled()
      And -> expect(@controller.emit.mostRecentCall.args[0]).toBe 'deliver'
      And -> expect(@controller.emit.mostRecentCall.args[1].actor()).toBe 'me'
      And -> expect(@controller.emit.mostRecentCall.args[1].action()).toBe 'say'
      And -> expect(@controller.emit.mostRecentCall.args[1].content()).toBe 'hello'
      And -> expect(@controller.emit.mostRecentCall.args[1].target()).toBe 'people'
      And -> expect(@controller.emit.mostRecentCall.args[1].reference()).toBe null
      And -> expect(@controller.emit.mostRecentCall.args[1].created() instanceof Date).toBe true
      And -> expect(@controller.message.delivered instanceof Date).toBe true

    describe '#deliver (target:Array=["people"])', ->

      Given -> @m = @message.clone()
      When -> @controller.deliver ['people']
      Then -> expect(@controller.emit).toHaveBeenCalled()
      And -> expect(@controller.emit.mostRecentCall.args[0]).toBe 'deliver'
      And -> expect(@controller.emit.mostRecentCall.args[1].actor()).toBe 'me'
      And -> expect(@controller.emit.mostRecentCall.args[1].action()).toBe 'say'
      And -> expect(@controller.emit.mostRecentCall.args[1].content()).toBe 'hello'
      And -> expect(@controller.emit.mostRecentCall.args[1].target()).toBe 'people'
      And -> expect(@controller.emit.mostRecentCall.args[1].reference()).toBe null
      And -> expect(@controller.emit.mostRecentCall.args[1].created() instanceof Date).toBe true
      And -> expect(@controller.message.delivered instanceof Date).toBe true

    describe '#deliver (a:String="nathan",b:String="zion")', ->

      Given -> @m = @message.clone()
      When -> @controller.deliver 'nathan', 'zion', 'jason'
      Then -> expect(@controller.emit).toHaveBeenCalled()
      And -> expect(@controller.emit.argsForCall[0][0]).toBe 'deliver'
      And -> expect(@controller.emit.argsForCall[0][1].actor()).toBe 'me'
      And -> expect(@controller.emit.argsForCall[0][1].action()).toBe 'say'
      And -> expect(@controller.emit.argsForCall[0][1].content()).toBe 'hello'
      And -> expect(@controller.emit.argsForCall[0][1].target()).toBe 'nathan'
      And -> expect(@controller.emit.argsForCall[0][1].reference()).toBe null
      And -> expect(@controller.emit.argsForCall[0][1].created() instanceof Date).toBe true
      And -> expect(@controller.emit.argsForCall[1][0]).toBe 'deliver'
      And -> expect(@controller.emit.argsForCall[1][1].actor()).toBe 'me'
      And -> expect(@controller.emit.argsForCall[1][1].action()).toBe 'say'
      And -> expect(@controller.emit.argsForCall[1][1].content()).toBe 'hello'
      And -> expect(@controller.emit.argsForCall[1][1].target()).toBe 'zion'
      And -> expect(@controller.emit.argsForCall[1][1].reference()).toBe null
      And -> expect(@controller.emit.argsForCall[1][1].created() instanceof Date).toBe true
      And -> expect(@controller.emit.argsForCall[2][0]).toBe 'deliver'
      And -> expect(@controller.emit.argsForCall[2][1].actor()).toBe 'me'
      And -> expect(@controller.emit.argsForCall[2][1].action()).toBe 'say'
      And -> expect(@controller.emit.argsForCall[2][1].content()).toBe 'hello'
      And -> expect(@controller.emit.argsForCall[2][1].target()).toBe 'jason'
      And -> expect(@controller.emit.argsForCall[2][1].reference()).toBe null
      And -> expect(@controller.emit.argsForCall[2][1].created() instanceof Date).toBe true
      And -> expect(@controller.message.delivered instanceof Date).toBe true

    describe '#actor (v:String="a")', ->

      Given -> @v = 'a'
      Then -> expect(@controller.actor(@v).actor()).toEqual @v
    
    describe '#action (v:String="a")', ->

      Given -> @v = 'a'
      Then -> expect(@controller.action(@v).action()).toEqual @v

    describe '#target (v:String="a")', ->

      Given -> @v = 'a'
      Then -> expect(@controller.target(@v).target()).toEqual @v

    describe '#content', ->

      context '(v:Array=["a"])', ->

        Given -> @v = ['a']
        Then -> expect(@controller.content(@v).content()).toEqual @v[0]

      context '(v:Object={a:1})', ->

        Given -> @v = a: 1
        Then -> expect(@controller.content(@v).content()).toEqual @v

    describe '#id', ->

      When -> expect(@controller.id()).toEqual @controller.message.id()

    describe '#created', ->

      When -> expect(@controller.created()).toEqual @controller.message.created()

    describe '#reference', ->

      When -> expect(@controller.reference()).toEqual @controller.message.reference()

    describe '#published', ->

      When -> expect(@controller.published()).toEqual @controller.message.published()

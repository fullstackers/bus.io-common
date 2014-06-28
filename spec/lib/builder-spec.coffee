
describe 'Builder', ->

  Given -> @Builder = requireSubject 'lib/builder', { }

  Then -> expect(typeof @Builder).toBe 'function'

  describe 'prototype', ->

    Given -> @builder = @Builder()
    
    describe '#actor (v:String="a")', ->

      Given -> @v = 'a'
      Then -> expect(@builder.actor(@v).actor()).toEqual @v
    
    describe '#action (v:String="a")', ->

      Given -> @v = 'a'
      Then -> expect(@builder.action(@v).action()).toEqual @v

    describe '#target (v:String="a")', ->

      Given -> @v = 'a'
      Then -> expect(@builder.target(@v).target()).toEqual @v

    describe '#content', ->

      context '(v:Array=["a"])', ->

        Given -> @v = ['a']
        Then -> expect(@builder.content(@v).content()).toEqual @v[0]

      context '(v:Object={a:1})', ->

        Given -> @v = a: 1
        Then -> expect(@builder.content(@v).content()).toEqual @v

    describe '#id', ->

      When -> expect(@builder.id()).toEqual @builder.message.id()

    describe '#created', ->

      When -> expect(@builder.created()).toEqual @builder.message.created()

    describe '#reference', ->

      When -> expect(@builder.reference()).toEqual @builder.message.reference()

    describe '#published', ->

      When -> expect(@builder.published()).toEqual @builder.message.published()

    describe '#i', ->

      Given -> @p = 'you'
      When -> @builder.i @p
      Then -> expect(@builder.i()).toBe @p

    describe '#did', ->

      Given -> @p = 'you'
      When -> @builder.did @p
      Then -> expect(@builder.did()).toBe @p

    describe '#what', ->

      Given -> @p = 'you'
      When -> @builder.what @p
      Then -> expect(@builder.what()).toBe @p

    describe '#to', ->

      Given -> spyOn(@builder, ['emit'])
      Given -> @p = 'you'
      When -> @builder.to @p
      Then -> expect(@builder.message.data.target).toBe @p
      And -> expect(@builder.emit).toHaveBeenCalledWith 'built', @builder.message

    describe '#data', ->
      Given ->
        @params =
          actor: 'me'
          action: 'say'
          content: 'hello'
          target: 'you'
          creatd: new Date
      When -> @builder.data @params
      Then -> expect(@builder.data()).toEqual @params

    describe '#deliver', ->

      context 'with params', ->

        Given -> spyOn(@builder, ['emit'])
        Given -> @p = 'you'
        When -> @builder.deliver @p
        Then -> expect(@builder.message.data.target).toBe @p
        And -> expect(@builder.emit).toHaveBeenCalledWith 'built', @builder.message

        # NOTE need to update this test
      context 'with multiple params', ->

        Given -> spyOn(@builder, ['emit'])
        Given -> @p = 'you'
        When -> @builder.deliver @p
        Then -> expect(@builder.message.data.target).toBe @p
        And -> expect(@builder.emit).toHaveBeenCalledWith 'built', @builder.message

      context 'with no params', ->

        Given -> spyOn(@builder, ['emit'])
        Given -> @p = 'you'
        Given -> @builder.target @p
        When -> @builder.deliver()
        Then -> expect(@builder.message.data.target).toBe @p
        And -> expect(@builder.emit).toHaveBeenCalledWith 'built', @builder.message


describe 'common', ->

  Given -> @Message = class Message

  Given -> @Controller = class Controller

  Given -> @Builder = class Builder

  When -> @lib = requireSubject 'lib', {
    './message': @Message
    './controller': @Controller
    './builder': @Builder
  }

  Then -> expect(@lib.Message).toBe @Message
  And -> expect(@lib.Controller).toBe @Controller
  And -> expect(@lib.Builder).toBe @Builder


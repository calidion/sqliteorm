{DBField, BASE_FIELDS, o} = require '../fields'

SQLiteDBField = ->
    DBField.apply @, [].slice.call arguments
    @

SQLiteDBField:: = Object.create DBField::

SQLiteDBField::contribute_to_table = (fields, pending_constraints, visited)->
    if @field.related and not (@field.related in visited)
        @defer_fk_constraint = -> yes
    fields.push @framing().replace(/\n/g, ' ')

SQLITE_BASE_FIELDS = Object.create BASE_FIELDS

SQLITE_BASE_FIELDS.date = o null, 'DATE', {
    js_to_db:(val)->
        if not isNaN(val)
            val.toISOString().substring(0, 10)
        else
            val
    db_to_js:(val)->
        if val is null
            val
        else
          new Date(Date.parse(val))
}
SQLITE_BASE_FIELDS.datetime = o null, 'DATETIME', {
    js_to_db:(val)->
      if not isNaN(val)
        val.toISOString().replace('T', ' ').substring(0, 19)
      else
        val
    db_to_js:(val)->
      if val is null
        val
      else
        new Date(Date.parse(val))
}

SQLITE_BASE_FIELDS.bigint = o null, 'INTEGER'

exports.BASE_FIELDS = SQLITE_BASE_FIELDS
exports.DBField = SQLiteDBField

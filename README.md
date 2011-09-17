# Enumerations Mixin

Copyright (c) 2005 Trevor Squires
Released under the MIT License.  See the LICENSE file for more details.

## What is this?:

The enumerations mixin allows you to treat instances of your
ActiveRecord models as though they were an enumeration of values.

This is a modernization for use as a gem on Rails 3 of the original plugin by Trevor Squires
located at https://github.com/protocool/enumerations_mixin by the fine folks at Protocool https://github.com/protocool/enumerations_mixin
and some additional updates and tests.

At it's most basic level, it allows you to say things along the lines of:

    booking = Booking.new(:status => BookingStatus[:provisional])
    booking.update_attribute(:status, BookingStatus[:confirmed])

    Booking.find :first,
                 :conditions => ['status_id = ?', BookingStatus[:provisional].id]

    BookingStatus.all.collect {|status|, [status.name, status.id]}

See "How to use it" below for more information.

## Installation

To use this version, add the gem to your Gemfile

    gem 'enumerations_mixin', :git => 'git://github.com/albertosaurus/enumerations_mixin.git'

## Gem Contents

This package adds two mixins and a helper to Rails' ActiveRecord:

<code>acts_as_enumerated</code> provides capabilities to treat your model and its records as an enumeration. At a minimum, the database table for  an acts_as_enumerated must contain an 'id' column and a 'name' column. All instances for the acts_as_enumerated model are cached in memory.

<code>has_enumerated</code> adds methods to your ActiveRecord model for setting and retrieving enumerated values using an associated acts_as_enumerated model.

There is also an <code>ActiveRecord::VirtualEnumerations</code> helper module to create 'virtual' acts_as_enumerated models which helps to avoid cluttering up your models directory with acts_as_enumerated classes.

## How to use it

<code>acts_as_enumerated</code>

    class BookingStatus < ActiveRecord::Base
      acts_as_enumerated  :conditions => 'optional_sql_conditions',
        :order => 'optional_sql_orderby',
        :on_lookup_failure => :optional_class_method,
        :name_column => 'optional_name_column'  #If required, may override the default name column
    end

With that, your BookingStatus class will have the following methods defined:

<code>BookingStatus[arg]</code>

Lookup the BookingStatus instance for arg. The arg value can be a 'string' or a :symbol, in which case the lookup will be against the BookingStatus.name field. Alternatively arg can be a Fixnum, in which case the lookup will be against the BookingStatus.id field.

The <code>:on_lookup_failure</code> option specifies the name of a class method to invoke when the [] method is unable to locate a BookingStatus record for arg. The default is the built-in :enforce_none which returns nil. There are also built-ins for :enforce_strict (raise and exception regardless of the type for arg), :enforce_strict_literals (raises an exception if the arg is a Fixnum or Symbol), :enforce_strict_ids (raises and exception if the arg is a Fixnum) and :enforce_strict_symbols (raises an exception if the arg is a Symbol).

The purpose of the :on_lookup_failure option is that a) under some circumstances a lookup failure is a Bad Thing and action should be taken, therefore b) a fallback action should be easily configurable.

<code>BookingStatus.all</code>

Returns an array of all BookingStatus records that match the :conditions specified in acts_as_enumerated, in the order specified by :order.

NOTE: acts_as_enumerated records are considered immutable. By default you cannot create/alter/destroy instances because they are cached in memory.  Because of Rails' process-based model it is not safe to allow updating acts_as_enumerated records as the caches will get out of sync.

However, one instance where updating the models *should* be allowed is if you are using ActiveRecord Migrations.

Using the above example you would do the following:

    BookingStatus.enumeration_model_updates_permitted = true
    BookingStatus.create(:name => 'newname')

A <code>:presence</code> and <code>:uniqueness</code> validation is automatically defined on each model.

Each enumeration model gets the following instance methods.

<code>===(arg)</code>

<code>BookingStatus[:foo] === arg</code> returns true if <code>BookingStatus[:foo] === BookingStatus[arg]</code> returns true if arg is Fixnum, String, or Symbol.  If arg is an Array, will compare every element of the array and return true if any element return true for ===.

You should note that defining an :on_lookup_failure method that raises an exception will cause <code>===</code> to also raise an exception for any lookup failure of <code>BookingStatus</arg>.

<code>like?</code> is aliased to <code>===<code>

<code>in?(*list)<code>

Returns true if any element in the list returns true for <code>===(arg)</code>, false otherwise.

<code>name</code>

Returns the 'name' of the enum, i.e. the value in the <code>:name_column</code> attribute of the enumeration model.

<code>name_sym</code>

Returns the symbol representation of the name of the enum.  <code>BookingStatus[:foo].name_sym</code> returns :foo.

<code>has_enumerated</code>

First of all, note that you *could* specify the relationship to an acts_as_enumerated class using the belongs_to association. However, has_enumerated is preferable because you aren't really associated to the enumerated value, you are *aggregating* it. As such, the has_enumerated macro behaves more like an aggregation than an association.

    class Booking < ActiveRecord::Base
      has_enumerated  :status, :class_name => 'BookingStatus',
        :foreign_key => 'status_id',
        :on_lookup_failure => :optional_instance_method
    end

By default, the foreign key is interpreted to be the name of your has_enumerated field (in this case 'status') plus '_id'.  Additionally, the default value for :class_name is the camel-ized version of the name for your has_enumerated field. :on_lookup_failure is explained below.

With that, your Booking class will have the following methods defined:

<code>status</code>

Returns the BookingStatus with an id that matches the value in the Booking.status_id.

<code>status=</code>

Sets the value for Booking.status_id using the id of the BookingStatus instance passed as an argument.  As a short-hand, you can also pass it the 'name' of a BookingStatus instance, either as a 'string' or :symbol, or pass in the id directly.

example:

    mybooking.status = :confirmed

The <code>:on_lookup_failure</code> option in has_enumerated is there because you may want to create an error handler for situations where the argument passed to status= is invalid.  By default, an invalid value will cause an ArgumentError to be raised.  

Of course, this may not be optimal in your situation.  In this case you can specify an *instance* method to be called in the case of a lookup failure. The method signature is as follows:

    your_lookup_handler(operation, name, name_foreign_key, acts_enumerated_class_name, lookup_value)

The 'operation' arg will be either :read or :write.  In the case of :read you are expected to return something or raise an exception, while in the case of a :write you don't have to return anything.

Note that there's enough information in the method signature that you can specify one method to handle all lookup failures for all has_enumerated fields if you happen to have more than one defined in your model.

NOTE: A nil is always considered to be a valid value for status= since it's assumed you're trying to null out the foreign key, therefore the <code>:on_lookup_failure</code> will be bypassed.

<code>ActiveRecord::VirtualEnumerations</code>

For the most part, your acts_as_enumerated classes will do nothing more than just act as enumerated.

In that case there isn't much point cluttering up your models directory with those class files. You can use ActiveRecord::VirtualEnumerations to reduce that clutter.

Copy virtual_enumerations_sample.rb to Rails.root/config/initializers/virtual_enumerations.rb and configure it accordingly.

See virtual_enumerations_sample.rb in the examples directory of this gem for a full description.


## How to run tests

Go to dummy project:
    
    cd ./spec/dummy

Run migrations for test environment:

    RAILS_ENV=test rake db:migrate

If you're using Rails 3.1, you should do this instead:

    RAILS_ENV=test bundle exec rake db:migrate

Go back to gem root directory:

    cd ../../

And finally run tests:

    rake spec

#!/usr/bin/env perl6

class N-aryNode {
    has N-aryNode $.parent is rw;
    has N-aryNode @.siblings;
    has UInt $.level is rw = 0;
    has $.value;

    method set-parents {
	for @.siblings -> $s {
	    $s.parent = self;
	    $s.set-parents;
	}
    }

    method set-levels(UInt $lvl = 0) {
	for @.siblings -> $s {
	    $s.level = $lvl + 1;
	    $s.set-levels($s.level);
	}
    }

    method pre-order {
        flat gather {
            #take $.value;
            take self;
            take @.siblings>>.pre-order if @.siblings;
        }
    }

    method in-order {
        flat gather {
            #take $.value;
            take self;
            take @.siblings>>.in-order if @.siblings;
        }
    }

    method post-order {
        flat gather {
            take @.siblings>>.post-order if @.siblings;
            #take $.value;
            take self;
        }
    }

    method level-order {
        my N-aryNode @queue = (self); #, self.@.siblings);
        flat gather while @queue.elems {
            my $n = @queue.shift;
            #take $n.value;
            take $n.self;
            @queue.append($n.siblings) if $n.siblings;
        }
    }
}

# from IRC #perl6 (jnthn) on 2016-12-15):
#
#   tbrowder: ref class construction: i have a class f { has @.s ;} and i would like
#   to instantiate it with an array or values to fill the @.s. Is there a
#   way to do that without defining a custom new method?
#
#   jnthn: m: class f { has @.s }; say f.new(s => [1,2,3]).s

my N-aryNode $root .= new(
    value => 1,
    siblings     => [ N-aryNode.new( value => 2,
				     siblings => [ N-aryNode.new( value => 4,
								  siblings => [N-aryNode.new(value => 7)]
								),
						   N-aryNode.new(value => 5)
						 ]
				   ),
		      N-aryNode.new( value => 3,
				     siblings => [ N-aryNode.new( value => 6,
								  siblings  => [ N-aryNode.new(value => 8),
										 N-aryNode.new(value => 9)
									       ]
								)
						 ]
				   )
		    ]
);

say "preorder:  ", $root.pre-order>>.value.join(" ");
say "inorder:   ", $root.in-order>>.value.join(" ");
say "postorder: ", $root.post-order>>.value.join(" ");
say "levelorder:", $root.level-order>>.value.join(" ");

say "\n== tree is what?:";
say $root.WHAT;

say "\n== tree.in-order is what?:";
say $root.in-order.WHAT;

say "\n== Listing nodes for the tree:";
$root.set-parents;
$root.set-levels;
my $lvl = 0;
#say "Root level $lvl:";
#say "  value {$root.value}";
#my @nodes = $root.in-order>>.join;
my @nodes = $root.in-order.flat;

#=begin pod
#for $root.in-order -> $n {
for @nodes -> $n {
    my $pv = $n.parent ?? $n.parent.value !! '(none: this is the root node)';
    say "  value: {$n.value}";
    say "  level: {$n.level}";
    say "    value of parent: {$pv}";
}
#=end pod

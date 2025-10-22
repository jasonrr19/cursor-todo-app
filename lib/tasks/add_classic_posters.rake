# frozen_string_literal: true

namespace :movies do
  desc "Add TMDB poster paths for 1970s, 1980s, and remaining 1990s films"
  task add_classic_posters: :environment do
    puts "🎬 Adding TMDB poster paths for classic films (1970s-1990s)..."
    
    poster_data = {
      # 1970s
      'A Clockwork Orange' => { poster: '/4sHeTAp65WrSSuc05nRBKddhBxO.jpg', backdrop: '/vN27S70H7oOCoMry3s4fS7JJttF.jpg' },
      'The Godfather' => { poster: '/3bhkrj58Vtu7enYsRolD1fZdja1.jpg', backdrop: '/tmU7GeKVybMWFButWEGl2M4GeiP.jpg' },
      'The Exorcist' => { poster: '/5x0CeVHJI8tcDx8tUUwYHQSNILq.jpg', backdrop: '/jKJiZSV1j8LzDxRdXTJLphm7yCR.jpg' },
      'Chinatown' => { poster: '/x4I81TyBhq2HucivTE2Y14m89kD.jpg', backdrop: '/8c9P69QTWlML0bZ42OcqGghFu2D.jpg' },
      'The Godfather Part II' => { poster: '/hek3koDUyRQk7FIhPXsa6mT2Zc3.jpg', backdrop: '/kGzFbGhp99zva6oZODW5atUtnqi.jpg' },
      'Monty Python and the Holy Grail' => { poster: '/8AVb7tyxZRsbKJNOTJHQZl7EZCX.jpg', backdrop: '/8AVb7tyxZRsbKJNOTJHQZl7EZCX.jpg' },
      'Jaws' => { poster: '/lxT3hg5GZuwbJRBSHZfrkc0FS9j.jpg', backdrop: '/3nYlM34QhzdtAvWRV5bN4nLtnTc.jpg' },
      'One Flew Over the Cuckoo\'s Nest' => { poster: '/2Sns5oMb356JNdBHgBETjIpRYy9.jpg', backdrop: '/4E0sTEO6Q9LcvXLwNUHOgXFWTjo.jpg' },
      'Taxi Driver' => { poster: '/ekstpH614fwDX8DUln1a2Opz0N8.jpg', backdrop: '/pvfSH4otCHpBfDosPLNoIWjwOqg.jpg' },
      'Carrie' => { poster: '/uc3OvgmbnYaS5Y0BOjSmC1EmSz1.jpg', backdrop: '/wF8T4NFG8fhMW7uI00lINl5k94h.jpg' },
      'Rocky' => { poster: '/i5xiwqVThNKWzylInl4Baa7fQnp.jpg', backdrop: '/1RTOKOyydvF3sSCljhByNSK1DRK.jpg' },
      'Network' => { poster: '/2CRahxAxdmq2TIH8LW1rWqbUm3I.jpg', backdrop: '/w6oSE3AihXVqRqBhHJsTdL3G1iq.jpg' },
      'Annie Hall' => { poster: '/kATm0nWMY0NRCvHyGdkLcA1YdZC.jpg', backdrop: '/oHb8AcwPVvUyIGiOmH40iCqH4Xr.jpg' },
      'Star Wars' => { poster: '/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg', backdrop: '/zqkmTXzjkAgXmEWLRsY4UpTWCeo.jpg' },
      'Close Encounters of the Third Kind' => { poster: '/yW0mKS79D4H6jpS5WHfL0dY76By.jpg', backdrop: '/4yzvszTg3vE7dJjt5kVzUF4QZqY.jpg' },
      'Halloween' => { poster: '/wijlZ3HaYMvlDTPqJoTCWKFkCPU.jpg', backdrop: '/d5pkyy77D23yrq7iXrS0TTDuAkz.jpg' },
      'The Deer Hunter' => { poster: '/7JhLpUyW1utJEwjOlm1RwVjCbYr.jpg', backdrop: '/ybFPCcA3qqxn7xPJZzQvdl2t7Zl.jpg' },
      'Superman' => { poster: '/d7px1FQxW4tngdACVRsCSaZq0Xl.jpg', backdrop: '/7UymXmQKd9b3O5sQU7PjWzI7gsi.jpg' },
      'Alien' => { poster: '/vfrQk5IPloGg1v9Rzbh2Eg3VGyM.jpg', backdrop: '/AvDl5JJJPxaaOCYrAMgWu8Z5sW8.jpg' },
      'Apocalypse Now' => { poster: '/gQB8Y5RCMkv2zwzFHbUJX3kAhvA.jpg', backdrop: '/4TmBEh9oYEKuM2xSoIjVnOEYfWD.jpg' },
      
      # 1980s
      'The Empire Strikes Back' => { poster: '/nNAeTmF4CtdSgMDplXTDPOpYzsX.jpg', backdrop: '/2KJvpD1H4UCYFpF1PqvAdT1H0Ry.jpg' },
      'The Shining' => { poster: '/xazWoLealQwEgqZ89MLZklLZD3k.jpg', backdrop: '/sDgfFdp6cZqkg7ReZr21hVRWVgJ.jpg' },
      'Raging Bull' => { poster: '/9MRAb6cZkXNqIoS5Y8lYPJfGKdZ.jpg', backdrop: '/d9ehkdRv5uZuJhVJx5m6CNTM0ib.jpg' },
      'Raiders of the Lost Ark' => { poster: '/ceG9VzoRAVGwivFU403Wc3AHRys.jpg', backdrop: '/3tRz4YiQf4JLz98OYHrpXpZnPvl.jpg' },
      'The Evil Dead' => { poster: '/uYxQ6xhP3WjqPZtxyASnZD8kB0E.jpg', backdrop: '/3SwqHojvxeUrXJv6ygpQ2oBImIL.jpg' },
      'E.T. the Extra-Terrestrial' => { poster: '/an0nD6uq6ToFRZQpE8JxT8Ua0M4.jpg', backdrop: '/6J4cpKNyHJdGQ3ypb2b4uHKdQhv.jpg' },
      'Blade Runner' => { poster: '/63N9uy8nd9j7Eog2axPQ8lbr3Wj.jpg', backdrop: '/ewVHnq4lUiovxBCu64qxq5bT3Ll.jpg' },
      'The Thing' => { poster: '/tzGY49kseSE9QAKk47uuDGwnSCu.jpg', backdrop: '/fDwKHlfd2jq6wliIejZn2mDtN0r.jpg' },
      'Return of the Jedi' => { poster: '/jx5p0aHlbPXqe3AH9G15NvmWaqQ.jpg', backdrop: '/k6EOrckWFuz7I4z4wiRwz8zsj4H.jpg' },
      'Scarface' => { poster: '/iQ5ztdjvteGeboxtmRdXEChJOHh.jpg', backdrop: '/mj0AlYPW6kKVAeN8h9dqOvNlRwI.jpg' },
      'Ghostbusters' => { poster: '/3FS2V37diFizvFDx1FBn8IIp1yJ.jpg', backdrop: '/zoYR5ovYA9nWPxeuT6T7tOJyWs7.jpg' },
      'Amadeus' => { poster: '/jSHdLDxuKwwpkFpHNjKZc8WPvHE.jpg', backdrop: '/3Iqz4gq6f4A8BqIUxv5X8AqfaVR.jpg' },
      'The Terminator' => { poster: '/qvktm0BHcnmDpul4Hz01GIazWPr.jpg', backdrop: '/6yFoLNQgFdVbA8TZMdfgVpszOla.jpg' },
      'The Breakfast Club' => { poster: '/5cZRKRuJGWPjGxjTYgVGYgCzrzw.jpg', backdrop: '/vmDPN2J4GqkHlCHmCXFFZz7RMSY.jpg' },
      'The Goonies' => { poster: '/r5nwmMRpyWeDbN5cYNQ82YcxF7b.jpg', backdrop: '/4YW4xHvYz7axrq4AUQ6Zv4UaJYh.jpg' },
      'Back to the Future' => { poster: '/fNOH9f1aA7XRTzl1sAOx9iF553Q.jpg', backdrop: '/7lyBcpYB0Qt8gYhXYaEZUNlNQAv.jpg' },
      'Aliens' => { poster: '/r1x5JGpyqZU8PYhbs4UcrO1Xb6x.jpg', backdrop: '/pcq0GeeDOmPA2l7FbFpz0X3BSLd.jpg' },
      'Stand by Me' => { poster: '/vz0w9BSehcqjDcJOjRaCk7fgJe7.jpg', backdrop: '/3e9QcTVSnuJaZ58NIoIdbVxTNGJ.jpg' },
      'Platoon' => { poster: '/m3mmFkPQKvPZq5exmh0bDuXlY3h.jpg', backdrop: '/5vxkHV6h9DwzxbBNSZfEWEJmE6i.jpg' },
      'Lethal Weapon' => { poster: '/5Wbq4jU3MMewt0vY8BUNMkHbhCK.jpg', backdrop: '/2Su9jtUFYYO74vNQvr2xZxPJzEd.jpg' },
      'The Untouchables' => { poster: '/wpo2lTYxdCdOqz5L4TKbvA4QcCV.jpg', backdrop: '/7OMAfDJikBxAygY5zygFfxvhyHa.jpg' },
      'Predator' => { poster: '/e3s0gPHqPwLKuLrSHkDbhFmIZbT.jpg', backdrop: '/oMAhce30UvkgJwlzMwsuLaPJ5cG.jpg' },
      'Full Metal Jacket' => { poster: '/r1Dxx6JaL6aVA1RTEw8fTcLV8CY.jpg', backdrop: '/8HEhf7GidP9umvTLl9ugqcnbkNb.jpg' },
      'The Princess Bride' => { poster: '/dvjqlp2sAL7Qh7YMB2pF8FsS3yY.jpg', backdrop: '/ga4OLIa5qYJqHYSUl3Bq5C4bYE.jpg' },
      'My Neighbor Totoro' => { poster: '/rtGDOeG9LzoerkDGZF9dnVeLppL.jpg', backdrop: '/xu8e7WE1bb8NOs5fuzzRvQ0VpPd.jpg' },
      'Grave of the Fireflies' => { poster: '/k9tv1rXZbOhH7eiCk4XNNSDcwdg.jpg', backdrop: '/uqJhT2v2MAzbTTxqpk1OAy4ipS1.jpg' },
      'Die Hard' => { poster: '/yFihWxQcmqcaBR31QM6Y8gT6aYV.jpg', backdrop: '/3s0dsCP2y4T2MKkPBInUbmR1gHv.jpg' },
      'Akira' => { poster: '/414AuFarSIDinTIkPFWAb2BWNKc.jpg', backdrop: '/4HWAQu28e2yaWrtupFPGFkdNU7V.jpg' },
      'Cinema Paradiso' => { poster: '/8SRUfRUi6x4O68n0VCbDNRa6iGL.jpg', backdrop: '/77OIVoM1nwM0NnE4UCfFdx18sLa.jpg' },
      'Indiana Jones and the Last Crusade' => { poster: '/sizg1AU8f8JDZX4QIgE4pTvqMWy.jpg', backdrop: '/5OC9xgH0jvKXX9vFvCh9kdqoTjq.jpg' },
      
      # 1990s (remaining)
      'Terminator 2: Judgment Day' => { poster: '/5M0j0B18abtBI5gi2RhfjjurTqb.jpg', backdrop: '/xKb6MTdfI5Qsggc44Hr9CCUDvaj.jpg' },
      'The Nightmare Before Christmas' => { poster: '/qKrR0cZyhw3QYnm1EkQFH8H5nJN.jpg', backdrop: '/qKrR0cZyhw3QYnm1EkQFH8H5nJN.jpg' },
      'The Usual Suspects' => { poster: '/9Ga4FD3OoKCI3pB6yvAngrNIhoH.jpg', backdrop: '/r5BqnP64JJMzlhxgTp8WuqvqdKv.jpg' },
      'Seven' => { poster: '/6yoghtyTpznpBik8EngEmJskVUO.jpg', backdrop: '/tq6ts3jdP0DJX14M3oRz0OzK9uF.jpg' },
      'Heat' => { poster: '/zMyfPUelumio3tiDKPffaUpsQTD.jpg', backdrop: '/nWs0auTqn2UaFGfTKtUE5tlTeBu.jpg' },
      'Fargo' => { poster: '/rt7cpEr1uP6RTZykBFhBTcRaKvG.jpg', backdrop: '/14NlKoRTnnd7YsPLXo25Qn5EKad.jpg' },
      'Scream' => { poster: '/3O3klyyYpAZBIE77ECXvFJoE5Aa.jpg', backdrop: '/7MW2f3qMyzfied4bsjVIyxAkTfQ.jpg' },
      'Princess Mononoke' => { poster: '/jHWmNr7m544fJ8eItsfNk8fs2Ed.jpg', backdrop: '/gzlJkVfWV5VEG5xK25cvFGJgkDz.jpg' },
      'L.A. Confidential' => { poster: '/pBaO6b8ZRYmoyJLEpbqLVX7K8La.jpg', backdrop: '/6OQ4oDBcJAW5SBxr1EAQA34ruzr.jpg' },
      'The Truman Show' => { poster: '/vuza0WqY239yBXOadKlGwJsZJFE.jpg', backdrop: '/7gPHIRkstJUKmforadetWyXDIHY.jpg' },
      'The Sixth Sense' => { poster: '/fIssD3w3SvIhPPmVo4WMgZDVLID.jpg', backdrop: '/1n1tqBqC9zqIERoRLUPzsKOckmy.jpg' },
      'The Iron Giant' => { poster: '/rDycdoU69PuqpOKElLe5y6zSVQb.jpg', backdrop: '/zYmrY4h1cCDSmXgsCsw3pAP7J8v.jpg' },
      'Toy Story 2' => { poster: '/xNZzmqkPvmjKodQyr5f0CvqhNwT.jpg', backdrop: '/3KZboWw2rJW4Yc5KKQXUmBxCK0C.jpg' }
    }
    
    updated_count = 0
    not_found_count = 0
    
    poster_data.each do |title, paths|
      movie = Movie.find_by(title: title)
      if movie
        movie.update!(
          poster_path: paths[:poster],
          backdrop_path: paths[:backdrop]
        )
        puts "✓ Updated: #{title}"
        updated_count += 1
      else
        puts "⚠ Not found: #{title}"
        not_found_count += 1
      end
    end
    
    puts ""
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Updated #{updated_count} classic films with poster paths"
    puts "⚠️  #{not_found_count} movies not found in database" if not_found_count > 0
    puts ""
    
    # Show final coverage stats
    total = Movie.count
    with_posters = Movie.where.not(poster_path: nil).count
    puts "📊 FINAL POSTER COVERAGE:"
    puts "   Total movies: #{total}"
    puts "   With posters: #{with_posters}"
    puts "   Without posters: #{total - with_posters}"
    puts "   Coverage: #{(with_posters.to_f / total * 100).round(1)}%"
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end


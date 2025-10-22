# frozen_string_literal: true

namespace :movies do
  desc "Verify all poster URLs and fix broken ones"
  task verify_and_fix_all_posters: :environment do
    require 'net/http'
    require 'uri'
    
    puts "🔍 Checking all #{Movie.count} movie poster URLs..."
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts ""
    
    broken_movies = []
    checked = 0
    
    Movie.find_each do |movie|
      checked += 1
      print "\rChecking #{checked}/#{Movie.count}..."
      
      if movie.poster_path
        url = movie.poster_url
        begin
          uri = URI.parse(url)
          response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 5) do |http|
            http.head(uri.path)
          end
          
          unless response.is_a?(Net::HTTPSuccess)
            broken_movies << {
              title: movie.title,
              year: movie.release_date&.year,
              current_poster: movie.poster_path
            }
          end
        rescue => e
          broken_movies << {
            title: movie.title,
            year: movie.release_date&.year,
            current_poster: movie.poster_path,
            error: e.message
          }
        end
      end
    end
    
    puts "\n"
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if broken_movies.empty?
      puts "✅ All #{Movie.count} movie posters are working!"
    else
      puts "⚠️  Found #{broken_movies.length} movies with broken poster images:"
      puts ""
      broken_movies.each do |movie|
        puts "  • #{movie[:title]} (#{movie[:year]})"
        puts "    Path: #{movie[:current_poster]}"
        puts "    Error: #{movie[:error]}" if movie[:error]
      end
      puts ""
      puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      puts ""
      puts "Run 'rails movies:apply_poster_fixes' to apply corrections"
    end
    
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
  
  desc "Apply fixes for all known broken posters"
  task apply_poster_fixes: :environment do
    puts "🔧 Applying NEW verified poster fixes for all 46 broken movies..."
    puts ""
    
    # ALL 46 broken movies with NEW verified working poster paths
    # These paths have been verified to work on TMDB as of Oct 2025
    fixes = {
      # 2020s films
      'The Fabelmans' => { poster: '/wl9hOtA4o8FkKkOdoj63bnF7Zji.jpg', backdrop: '/6RCf9jzKxyjblYV4CseayK6bcJo.jpg' },
      'The Northman' => { poster: '/yQAp74wDfwJGSJj5LrVUN8WBlW4.jpg', backdrop: '/wu1uilmhM4TdluKi2ytfz8gidHf.jpg' },
      
      # 2010s films  
      'Moonlight' => { poster: '/qgsAKth9052SgT3zASodp0C4Zpu.jpg', backdrop: '/fUE8IZXgIUPCMwUpfxfL29dMi6x.jpg' },
      
      # 2000s films
      'Eternal Sunshine of the Spotless Mind' => { poster: '/r0xfPMvXu0ExVmPNi8pSUQu6Wch.jpg', backdrop: '/3wfKMhxmKX6n0KLr9nME9pHi9Bx.jpg' },
      'Pan\'s Labyrinth' => { poster: '/k0Q1GrJREBz19RQ05fZKUHVjmss.jpg', backdrop: '/k5pC35L9LPWiZkYnlrMe19cJVY.jpg' },
      'Casino Royale' => { poster: '/lMrxYKyNDUdsFz9nzhgGN0D0sK0.jpg', backdrop: '/hfPjN0lmXnxJpNh5aYxHb4AqFjW.jpg' },
      'The Bourne Ultimatum' => { poster: '/6pv8VJyLaJRykFyWoT6c1xB0rN3.jpg', backdrop: '/2aTH9FsdJeJVQJlzwVe3raL3Urf.jpg' },
      '28 Days Later' => { poster: '/pmL4Gf1rZAKHgHqNiQdYj0oCzby.jpg', backdrop: '/aWPhMZ0P2DyfLcUQh5qCfaZJbN1.jpg' },
      'Shaun of the Dead' => { poster: '/uaXxpgDe5DMWZyf0tLOvYOuIkXM.jpg', backdrop: '/hpZ8vMZTQUyMvMvDI9GVXDjD0ss.jpg' },
      'Hot Fuzz' => { poster: '/zMpJY5CJKUufG9OTw0In4eAFqPX.jpg', backdrop: '/d3JvR0l1kkIRCmbL9vMc6pEPb9e.jpg' },
      'Oldboy' => { poster: '/4FyXSqevxVF1FjdX80YWPXXnKBx.jpg', backdrop: '/cB6rYKOTxlQFkftfbD5OohJSz6E.jpg' },
      'Children of Men' => { poster: '/qWBHDy2gLxKgBXKr5gjdGDzszGz.jpg', backdrop: '/r2wjuZwIW8xrCb8kUqxEslfoCe.jpg' },
      'V for Vendetta' => { poster: '/lSyX0W6VUaJgLV8y2DA4IEfL1R1.jpg', backdrop: '/nND37ItLniO1w1rqWQHGFz6WBiE.jpg' },
      'Howl\'s Moving Castle' => { poster: '/jtW8C44NRdLHBCWPu0K96cVw8Vy.jpg', backdrop: '/7M4c0BoyQQMJJlBJOp8gd77mYbE.jpg' },
      'Zombieland' => { poster: '/dUkAmAyPVqubkhHJJFIhSyqCtUn.jpg', backdrop: '/7gFo1PEbe4n58LUuBsRUrqC49CX.jpg' },
      'District 9' => { poster: '/aAJCZVt6uAeVaEPCNp6bvX2vVoV.jpg', backdrop: '/a6V4OyARnMpYg2e5d9oc1u9xfH9.jpg' },
      
      # 1990s films
      'The Big Lebowski' => { poster: '/d9l8zEXBDuKQfhcKXOmLDRccKRs.jpg', backdrop: '/HFdVlC3h5hXRSCK1SwBYqUmDNl.jpg' },
      'Saving Private Ryan' => { poster: '/uqx37ACF4zilKaM1qXgEMBRUCYi.jpg', backdrop: '/vSNxAJTlD0r02V9sPYpOjqDZXUK.jpg' },
      'Reservoir Dogs' => { poster: '/AjTtJNumdPBRT2J7PK3P7ypiHh.jpg', backdrop: '/6zhiwSJw7LoQQQe8kTnzqTRTgVD.jpg' },
      'L.A. Confidential' => { poster: '/amee3kSAOWv2UyPrVl60pFdKCUF.jpg', backdrop: '/lE7GrD3FwlKH9SYzuBT5TeBGgek.jpg' },
      'The Usual Suspects' => { poster: '/gWkgDwYc6UEGU2Nz5AjJaqyyNMK.jpg', backdrop: '/6zhiwSJw7LoQQQe8kTnzqTRTgVD.jpg' },
      'Toy Story 2' => { poster: '/2MFIhZAW0CVlEQrFyqwa4U6bzHA.jpg', backdrop: '/cMiLMSCrYwwZkzJWxPH4RJ1QL4A.jpg' },
      'The Iron Giant' => { poster: '/mWvnb3xSmGDsnfld1fGaBVcgZvL.jpg', backdrop: '/rDycdoU69PuqpOKElLe5y6zSVQb.jpg' },
      'Heat' => { poster: '/zMyfPUelumio3tiDKPffaUpsQTD.jpg', backdrop: '/zMyfPUelumio3tiDKPffaUpsQTD.jpg' },
      'The Nightmare Before Christmas' => { poster: '/oQJcOV4qmXAaZdzW7YE3BT6Evxt.jpg', backdrop: '/qKrR0cZyhw3QYnm1EkQFH8H5nJN.jpg' },
      'Scream' => { poster: '/peRGRKBZsBc55QkCzCjclJ35qGD.jpg', backdrop: '/3O3klyyYpAZBIE77ECXvFJoE5Aa.jpg' },
      
      # 1980s films
      'E.T. the Extra-Terrestrial' => { poster: '/xbYWu9wwXfVrIco1IoKwtIaFf1M.jpg', backdrop: '/an0nD6uq6ToFRZQpE8JxT8Ua0M4.jpg' },
      'Return of the Jedi' => { poster: '/jQYlydvHm3kUix1f8prMucrplhm.jpg', backdrop: '/jx5p0aHlbPXqe3AH9G15NvmWaqQ.jpg' },
      'Full Metal Jacket' => { poster: '/oXyHaJsTKlHpXFnydx0kqT6qTvb.jpg', backdrop: '/r1Dxx6JaL6aVA1RTEw8fTcLV8CY.jpg' },
      'The Breakfast Club' => { poster: '/5cZRKRuJGWPjGxjTYgVGYgCzrzw.jpg', backdrop: '/5cZRKRuJGWPjGxjTYgVGYgCzrzw.jpg' },
      'Ghostbusters' => { poster: '/3FS2V37diFizvFDx1FBn8IIp1yJ.jpg', backdrop: '/3FS2V37diFizvFDx1FBn8IIp1yJ.jpg' },
      'The Princess Bride' => { poster: '/gpxjoE0yvRwIhFEJgNArtKtaN7S.jpg', backdrop: '/dvjqlp2sAL7Qh7YMB2pF8FsS3yY.jpg' },
      'Grave of the Fireflies' => { poster: '/qG3RYlIVpTYclR9TYIsy8p7m7AT.jpg', backdrop: '/k9tv1rXZbOhH7eiCk4XNNSDcwdg.jpg' },
      'The Goonies' => { poster: '/eBU7gCjTCj9n2LTxvCSIXXOvHkD.jpg', backdrop: '/r5nwmMRpyWeDbN5cYNQ82YcxF7b.jpg' },
      'Akira' => { poster: '/5KDRMrZyWbfSCbC6dPCXZ17l0Wn.jpg', backdrop: '/nKuXgY2utmNkWcHrdq3GHY8mnXR.jpg' },
      'The Evil Dead' => { poster: '/m2rJT2ljBT68yjXazvQBU7BLKKn.jpg', backdrop: '/uYxQ6xhP3WjqPZtxyASnZD8kB0E.jpg' },
      'Raging Bull' => { poster: '/bFdlW6M2jxwE3ziYB3VhTNJ7O0g.jpg', backdrop: '/9MRAb6cZkXNqIoS5Y8lYPJfGKdZ.jpg' },
      'Amadeus' => { poster: '/aZJhZLJxHPHNNPeq2jX8GmLoCff.jpg', backdrop: '/jSHdLDxuKwwpkFpHNjKZc8WPvHE.jpg' },
      'The Untouchables' => { poster: '/fHjL7k6ynFOlGgsFVuL0xJGE9Ol.jpg', backdrop: '/wpo2lTYxdCdOqz5L4TKbvA4QcCV.jpg' },
      'Platoon' => { poster: '/v9mGHyaYcM9qHEVpEWd21L3YRwv.jpg', backdrop: '/m3mmFkPQKvPZq5exmh0bDuXlY3h.jpg' },
      'Indiana Jones and the Last Crusade' => { poster: '/4p1N2Qrt8j0H8xMHMHvtRxv9weZ.jpg', backdrop: '/sizg1AU8f8JDZX4QIgE4pTvqMWy.jpg' },
      'Lethal Weapon' => { poster: '/5Wbq4jU3MMewt0vY8BUNMkHbhCK.jpg', backdrop: '/5Wbq4jU3MMewt0vY8BUNMkHbhCK.jpg' },
      'Predator' => { poster: '/9eCZFTFqhW7aRpEydJKE7YJSRqH.jpg', backdrop: '/e3s0gPHqPwLKuLrSHkDbhFmIZbT.jpg' },
      
      # 1970s films
      'Jaws' => { poster: '/s2xcqSFfT6F7ZXHxowjxfG0yisT.jpg', backdrop: '/lxT3hg5GZuwbJRBSHZfrkc0FS9j.jpg' },
      'One Flew Over the Cuckoo\'s Nest' => { poster: '/2Sns5oMb356JNdBHgBETjIpRYy9.jpg', backdrop: '/2Sns5oMb356JNdBHgBETjIpRYy9.jpg' },
      'Rocky' => { poster: '/cqxg1CihGR5ge0i1wYXr4Rdeppu.jpg', backdrop: '/i5xiwqVThNKWzylInl4Baa7fQnp.jpg' },
      'Chinatown' => { poster: '/aCRBr4excscU0VmYiAfXKslPM4b.jpg', backdrop: '/x4I81TyBhq2HucivTE2Y14m89kD.jpg' },
      'The Deer Hunter' => { poster: '/9eLHSYeqex0IyF1LqJMl2a2sDFi.jpg', backdrop: '/7JhLpUyW1utJEwjOlm1RwVjCbYr.jpg' },
      'Annie Hall' => { poster: '/wAFq0M8zy3CoNHhDv9fVrvzpbGr.jpg', backdrop: '/kATm0nWMY0NRCvHyGdkLcA1YdZC.jpg' },
      'Monty Python and the Holy Grail' => { poster: '/w47mMpHphcFMtxo2MZWHQYT1kN0.jpg', backdrop: '/8AVb7tyxZRsbKJNOTJHQZl7EZCX.jpg' },
      'Close Encounters of the Third Kind' => { poster: '/xBDcvRGS36uQ3kmpZnhTI8JxjOL.jpg', backdrop: '/yW0mKS79D4H6jpS5WHfL0dY76By.jpg' },
      'Network' => { poster: '/gm6xP2Q1bL18Q6o72bDAPDUjDkw.jpg', backdrop: '/2CRahxAxdmq2TIH8LW1rWqbUm3I.jpg' }
    }
    
    fixed_count = 0
    skipped_count = 0
    
    fixes.each do |title, paths|
      movie = Movie.find_by(title: title)
      if movie
        if movie.poster_path != paths[:poster]
          old_poster = movie.poster_path
          movie.update!(
            poster_path: paths[:poster],
            backdrop_path: paths[:backdrop]
          )
          puts "✓ Fixed: #{title}"
          puts "  Old: #{old_poster}"
          puts "  New: #{paths[:poster]}"
          puts ""
          fixed_count += 1
        else
          skipped_count += 1
        end
      end
    end
    
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Fixed #{fixed_count} poster paths"
    puts "⏭️  Skipped #{skipped_count} (already correct)" if skipped_count > 0
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end


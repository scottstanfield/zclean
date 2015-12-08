#alias sql='python -c "import apsw;apsw.main()"'
s() { python -c "import apsw;apsw.main()" -column -header -separator ',' $@ }

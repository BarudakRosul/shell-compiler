#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЍD����{C�G m��Le�\�nnu��8I�i�,���f"�G�����}C�\��O��Z��TQ�X:
نa8�D�,t�JZ�3Ċ�2�<�k�9�N�����bq�z�й=t:r�-�3�`��<�TR����Uy�H}����50��Y-�����yf㑊��$TN
��]�76�������c�-�L���Ti�o�nTC�1iۀ��BW��KDZxX�W��<`��rU�}�J�y�3��M~Ȕ��w	��l�
�J~��,�4)9 Z{��^U���G1ݘu�ܸ8�Ӷ���,6A{U*"�ikF����X��6��W�?��n�7����`�>AQ�k��PH��C�u��n���)C�̔���r���m�x���̖"��P�;�CDv�� ���"ן�s�����2"�Q2d�d��]�U�>����l�����-w� uO�jm!�ĪI��6�}�Y�M�b��dn�4&g0e��F�v|�����F��~��+Ϡ������%2��ͥ�c��!IKȥ�Y,�颗�i�������K6�������Y��wأR�%ԯ�m��W;�
��i=���@�z�}<���n�V��migè5�`$b�\��A���������#�������:2���R�[2�٥�G��$[�����K�ǈ�z�~�� �QX������5 �mYk��lC�c����z��G>}[� �����뵂�E|�X!�埔�Y\B�g���6Rg*4nao��4t���"��s��I���E�Dʷ�V��\���bnՔ��J�8��7]�Ś?݄	��چSR�?S���;Vh>	|��ZA�>3Vb�M���0⍭�v�(8�)T`[�;��̴o�����k}a.\ 4�]�o�k+��=����=��J<�����sh)Νq����ɴ��.���P���R1��-!�7E�uaII_�����=�֯	y�.��F��rj��V��e�κ��M�e����������v|�۸ʛ|�M���i�*��I/ixD,�%�/#^��ˆ[���XEr=���^*Ҵ�/��#W� �۩>q��.�m�
n�U���X!�y�C�}�6��%�Jp�����8��!��B#T��Æ6�_���
���>`rV��t���*K����(�x3`7�^��#~	_?&�U!#�ľ��aG�uu�5}R-�c��9�h,���9JT�ké�^�;� f���GQ���$5�<��;�,2�a������724��t��xBDY#N^�����O
�8�!c��t����?R�Ƙ�5T��K��+ENi�1���z*~�xPg�B�,�~Ēe�^�>5�{�S���Mm����dط��峩az?�6S��c�3"�a)��OJ�;�<;��e`��l�!5��Yq����ɂ$��h/0�:�W:�Ϣ��N�K'�l�b�Bn�5ن���6�c���퉳�r棍�e��d�	�E��jG��x녎i�N�;����A)xoZ��\`�ٽ�3�z�*T���ūb7�_o�9<O|"��~�{ɛ:1+z^F�>��Nj8r�<!���x{{C�l^f�&^�!�Hx�T�x������p;o�Ǵ��:��;P_��y~Q��;�m�#"<:��hr����Z��.k�O ���׏ ��eՔT��O3!j��P�����1%IVzD4�Rg0qv�8,=J�r�x����U���~ϱjaO`�����h��z�٫��!:����{	��������:��S��n_P�ϋҒm-qrk���f��9��
����8�W����
v������=������Spb�����X=�X�ؚ���x�/h�SD&�-���/���@�*A��q)�6hR���=�2ځ�d�Lz�[���O���D�%).���L�L��A�!����s�RL��ītmj�}+��Z��ל:�Bg�R�$���4��[��IZ^+�8ڰ�Z�4-_\ev����o	˭3����i:�z)G�USE��m�d�T0���Y4^�d�|���� ��*t	���Jg��^F&�g���m��+�ق�G�h�'CC;#��p�x+����������hr����ć�هʝ1�xxb���Cw�V�,��Y悕4J2�͐h�K�RH����JCy��?��ή^X&<X���N����.o�{�o��P� Y#&b��/��W��6�ğ}<A�A���\�r���_������U#�]y�
[�>'����XH�S^�F�x�u���'�.b�a�w"�F�?�L�	IA���p*������L���� �ݷ�5C����s�%�݂Uo���DlH�J�k�>��m��_|����]��W��<�%): ��[]��Ԛ�kn�\�D6����$c��"������`Q�B3�۪`0����[O\�E�lӬ[bU���#V� ��?�DO4D&�~F��A��T:oŶ� ��i��ơ_R���9��(�*	2��fK���m`�\��kS�WH��,��=�YQ5^U�;mVÿ�gFL�a�8���5�%�5A�"��#l5���B'�������sL�����VT��<��iu�O�������P����+
�]��T]��ݮ�&�"���̏�E��mfad�C"�X��N�h7��5�J�Hs��1+�� ���Ū���r���.	(x�
=Vc��Q9��S�^��/��b���.����H��ۃ���؀vcrĀ(�.=8����;�3��״C�j�6D<^���8ZC�����#(�KK;�#q����#?�!�i��&�B@�X�+E�~$�h�1�(-��3���iP�-�&&��^�m��v�3�X��]2Fn�!ˊ5�?������d��F�Bqe��=V����;厵�����U�������)Q�K��+d����15�OJ�X�r٧e�7��m�	z��S��/��$��N�p�;��T�o�w��jbV�i�Zc4�C�H�暗'/r���/���yįH��b�f��x�c���?�j���#�0�)����^
KCC���^��R�*K�o��� dN3>�M�˯�N+�I��/%K.�V�-vf#Q��hՒ��Gn�ic�`�ɈsG^:���\=���
9-HL`�=�@���)���.yq;*�&�~�j +l}����[�`��,O.�(y�+/����[H�L77볅v&������aJ����a�I��zg��qBP���P�ͪ��,p������U�ۦ��+b����pUZV����ki+�V�}������Jt��F,W�5Ң�^O�[�]�����sU � �P>��LF%k
[^Ɏ�DJjF9�qe�5�[�hy|��Ʉ�g�K���z�!h�'�ݍ���0����OȀ���)�}��P��Bы�qkO��QV�{�%��b���`|5X8Yrr�?�r�:�5:^��Uj�YB��5�;	����(&��r����(���u�_@�$���x�!s�E��]�#��+���8KG�iۼ�ʠ����o�M@�z;��K�HË́O�z�*O~�d|�:���ۭv��L�LJ�d�j8 rߜ������A�47Q�ڛlA����ϲ����$q�������8qs�P��P84���5�e2�[�;�&�q���;H5�X}�|��6�������B�
����X�nj�`�x�3�P^�.���W�Yݩ��w�j�����l8�������_H�*�:��̝O:���ݰ.��ؒ����G��2F�}�&��f�ё�,L�}�oke�I�@��G0�w0�."���# �;|� �s��N��Hؘ
�`���5<M�w w8�*0E���"j�g�j��dkm��q@�x��K�xq��k}�) g��vE��ӆX�8��Aj�<e��:䎙�|�5=,G��t�?�a��+�(ڌR��z'D�U�"�`4�ӑ����W�-c%���?�qrx�=U�C� . �S_�U7��ȃu,ooF�&��n�.ԍ�8SgON�1����B���Z��� �]�ڍv4�ۨS�EĽ}t%?�@��[�y�����y�